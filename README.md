# ❄️ OpenClaude Nix Flake

This repository provides a **Nix Flake** for [OpenClaude](https://github.com/gitlawb/openclaude).

-----

## ✨ Features

  * **Zero-Global-Install:** No need for `npm install -g` or `bun` on your host system.
  * **Hermetic Build:** Uses `buildNpmPackage` with a vendored `package-lock.json` for 100% reproducibility.
  * **Bun Integrated:** Automatically handles the Bun-based build scripts inside the Nix sandbox.
  * **Ready for NixOS:** Easily importable into `configuration.nix` or `home-manager`.

-----

## 🚀 Quick Usage (No Install)

Run the tool immediately from this flake:

```bash
nix run github:alessandromalacarne/openclaude-flake
```

-----

## 🛠️ Installation

### 1\. Add to your NixOS Configuration

Add this flake to your `inputs` and include it in your system packages:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    openclaude-flake.url = "github:alessandromalacarne/openclaude-flake";
  };

  # ...
          environment.systemPackages = [ 
            openclaude-flake.packages.${pkgs.system}.default 
          ];
  # ...
}
```

### 2\. Home Manager

If you prefer managing packages via Home Manager:

```nix
home.packages = [
  inputs.openclaude-flake.packages.${pkgs.system}.default
];
```

-----

## 🏗️ Technical Architecture

The build process is designed to comply with Nix's read-only sandbox:

1.  **Source Fetching:** Pulls the source from the official repository.
2.  **Lockfile Injection:** Upstream lacks a lockfile; we inject a generated `package-lock.json` via `postPatch` to satisfy `buildNpmPackage`.
3.  **Sandbox Build:** Executes `npm install` and the Bun-based `scripts/build.ts` in a network-isolated environment.
4.  **Binary Wrapping:** Uses `makeWrapper` to ensure the final executable is correctly linked to the Nix Store's `nodejs` binary.

### Development Commands

  * **Build locally:** `nix build .#default`
  * **Check outputs:** `nix flake show`
  * **Debug shell:** `nix develop`

-----

## 🤝 Credits

  * **Upstream Tool:** [OpenClaude](https://github.com/gitlawb/openclaude) by @gitlawb.
-----

## ⚖️ License

This flake follows the license of the original OpenClaude project.
