# Using a Debian Linux base image specifically designed for toolbox or development environments.
# This is an edge version, which means it could include the latest features but might be less stable.
FROM quay.io/toolbx-images/debian-toolbox:12

# Labels are key-value pairs providing additional information about the image.
# These labels indicate the image is intended for use with toolbox or distrobox commands,
# provide a brief summary, and specify a maintainer email.
LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="palomar.research@gmail.com"

# Copying 'extra-packages' and 'build-packages' files from the host into the image.
# These files presumably contain a list of additional packages to be installed.
COPY extra-packages /
COPY build-packages /

# Updating and upgrading the Debian package index,
# then installing additional packages specified in 'extra-packages' and 'build-packages'.
# Packages starting with '#' are ignored, allowing for comments in the packages list.
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    grep -v '^#' /extra-packages | xargs apt-get install -y && \
    grep -v '^#' /build-packages | xargs apt-get install -y

# # Cloning the Emacs repository from its official Git repository, specifically the emacs-29.1 branch.
# # Then, it compiles and installs Emacs with native compilation, without X support, and with libsystemd.
# # This suggests a focus on a headless, possibly server or cloud-based environment.
# RUN git clone https://git.savannah.gnu.org/git/emacs.git --depth 1 --branch emacs-29.1 && \
#     cd emacs && \
#     autoreconf -fi && \
#     ./configure --prefix=/usr --with-native-compilation=yes --with-libsystemd --with-libgmp --with-modules --with-x-toolkit=gtk3 --without-xaw3d && \
#     make install

COPY emacsclient.desktop.patch /

# Cloning the Emacs repository from its official Git repository, specifically the emacs-29.1 branch.
# Then, it compiles and installs Emacs with native compilation, without X support, and with libsystemd.
# Applying the emacsclient.desktop.patch.
# This suggests a focus on a headless, possibly server or cloud-based environment.
RUN git clone https://git.savannah.gnu.org/git/emacs.git --depth 1 --branch emacs-29.1 && \
    cd emacs && \
    autoreconf -fi && \
    ./configure --prefix=/usr --with-native-compilation=yes --with-libsystemd --with-libgmp --with-modules --with-x-toolkit=lucid --without-xaw3d && \
    patch -p1 < /emacsclient.desktop.patch && \
    make install

COPY emacs.service /usr/lib/systemd/system

# Removing the packages specified in 'build-packages' to reduce the image size,
# and deleting project files to clean up.
RUN grep -v '^#' /build-packages | xargs apt-get remove --purge -y && \
	apt-get autoremove -y && \
    rm /extra-packages /build-packages /emacsclient.desktop.patch

# Creating symbolic links for various commands (docker, flatpak, podman, etc.) to the 'distrobox-host-exec'.
# This setup is likely designed to allow these commands to work seamlessly in a distrobox environment.
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
