# Emacs-Portable

## Description

`emacs-portable` is a containerized version of Emacs, tailored for use with Distrobox. This project is particularly useful for immutable Linux distributions, and it has been tested on Fedora Silverblue Bluefin ([projectbluefin.io](https://projectbluefin.io)). Based on Debian 12, it includes Emacs 29.1 with native compilation and the Lucid X toolkit for enhanced stability. The container also packs tools commonly used by various Emacs packages, like rg, fd, git, pandoc, and shellcheck, and has been specifically tested with [Doom Emacs](https://github.com/doomemacs/doomemacs).

## Building the Image

To build the `emacs-portable` image:

1. Clone the repository:

   ```bash
   git clone https://github.com/rafaelpalomar/emacs-portable.git
   cd emacs-portable
   ```

2. Build the container image:

   ```bash
   podman build -t quay.io/rafael_palomar/emacs-portable:latest .
   ```

3. Optionally, push the image to Quay.io (requires authentication):

   ```bash
   podman push quay.io/rafael_palomar/emacs-portable:latest
   ```

## Using emacs-portable with Distrobox

To use `emacs-portable` with Distrobox:

1. Create a new Distrobox container:

   ```bash
   distrobox create -i quay.io/rafael_palomar/emacs-portable:latest -n emacs-portable
   ```

2. Enter the Distrobox container:

   ```bash
   distrobox enter emacs-portable
   ```

## Installing Doom Emacs

To install Doom Emacs inside your `emacs-portable` container:

1. Clone the Doom Emacs project on the host:

   ```bash
   git clone https://github.com/doomemacs/doomemacs.git
   ```

2. Enter the Distrobox container:

   ```bash
   distrobox enter emacs-portable
   ```

3. Navigate to the Doom directory and run the installation script:

   ```bash
   cd doomemacs
   ./bin/doom install
   ```

## Exporting .desktop Application

To export `emacs-portable` as a `.desktop` application:

1. Enter the Distrobox container:

   ```bash
   distrobox enter emacs-portable
   ```

2. Export the Emacs application:

   ```bash
   distrobox-export --app emacs
   ```

## Experimental: Emacs Daemon via Systemd User Service

Inside the distrobox, you can enable an experimental systemd user service for Emacs:

1. Enter the Distrobox container:

   ```bash
   distrobox enter emacs-portable
   ```

2. Enable and start the `emacs.service`:

   ```bash
   systemctl --user enable emacs.service
   systemctl --user start emacs.service
   ```
   
Subsequent uses of the distrobox will start the emacs server automatically.

## Verifying the Image with Cosign

To verify the signed container image:

1. Download the `cosign.pub` key from the repository.

2. Run the following command to verify the signature:

   ```bash
   cosign verify --key cosign.pub quay.io/rafael_palomar/emacs-portable:latest
   ```

## Contributions and Feedback

Your contributions and feedback are welcome! Feel free to open issues or pull requests on [GitHub](https://github.com/rafaelpalomar/emacs-portable).
