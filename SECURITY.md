# Security Policy

This document outlines the security policy for **Carto**, our proactive approach to safety during development, and the protocol for reporting vulnerabilities.

## Supported Versions

As Carto is currently a functional prototype, security updates and support are focused on the most recent release.

| Version         | Supported | Notes                                                               |
| --------------- | --------- | ------------------------------------------------------------------- |
| Latest (v0.1.0) | ✅         | Main development branch with the latest architectural improvements. |
| < v0.1.0        | ❌         | Legacy development versions are no longer supported.                |

## Security Approach for the Prototype

While **Carto** is a UI/UX-focused prototype without a real backend, it has been built following security best practices to ensure a solid and reliable foundation:

* **External Security Analysis**: The release APK was analyzed using **MobSF (Mobile Security Framework)** as an exercise in mobile security awareness and validation.
* **Non-Sensitive Data Management**: Local persistence is strictly limited to basic, non-sensitive profile data such as name, email, and profile picture.
* **No Real Credentials**: The application does not store passwords, real authentication tokens, or financial information, significantly reducing the prototype's attack surface.
* **Decoupled Architecture**: The clear separation between the UI and business logic (Providers) allows for future implementation of security layers, such as data encryption, without impacting the interface.

## Reporting a Vulnerability

If you discover a security vulnerability, please help us keep the project safe by following these steps:

1.  **Do not open a public Issue** to report security-related flaws.
2.  Report the finding by opening a **Private Security Advisory** within this repository.
3.  Alternatively, you may contact the repository owner directly.

We appreciate your collaboration in keeping this educational project secure.

## Scalability Towards Production

The current architecture is designed to facilitate a secure transition to a production environment by easily integrating:
* Real authentication systems and secure session management.
* Encrypted local persistence for sensitive user data.
* Secure connections (HTTPS) with certificate pinning.