# ELRA to ELG XML Converter

This project provides a set of scripts and tools to transform ELRA XML files into ELG-compatible XML files. It automates the conversion process while ensuring compatibility with the ELG schema.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Scripts](#scripts)
- [License](#license)

## Overview
This project offers a bash script and supporting XSLT files to convert XML files from the ELRA schema to the ELG schema. The transformation process involves multiple steps including XML validation, namespace changes, and application of specific XSL transformations.

## Features
- Converts ELRA XML files to ELG-compatible XML files.
- Validates XML files using `xmllint`.
- Automatically handles namespace changes.
- Modular XSL transformation scripts.
- Supports validation of multiple XML files in bulk.

## Prerequisites
Ensure the following are installed:
- **Java Runtime Environment (JRE)**
- **xmllint** (Install using `sudo apt-get install libxml2-utils`)
- **Saxon-B XSLT Processor** (Install using `sudo apt-get install libsaxonb-java` and update the `CLASSPATH` environment variable.)

## Installation
To set up the environment and install the necessary tools, use the following steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/elra-to-elg-xml-converter.git
    cd elra-to-elg-xml-converter
    ```

2. Install `shellcheck` (optional, for script linting):
    ```bash
    ./shellcheck-install.sh
    ```

## Usage
To convert an ELRA XML file to an ELG XML file, use the following command:
```bash
./convert-to-elg.sh path/to/your/elra-file.xml [path/to/ELG-SHARE_XSD.xsd]
```

### Parameters:
- `XML_FILE`: The path to the input ELRA XML file.
- `ELG_SHARE_XSD` (optional): The path to the ELG schema file for validation.

### Example:
```bash
./convert-to-elg.sh sample-elra-file.xml elg-schema.xsd
```

## Scripts
This project contains the following scripts:

### 1. `convert-to-elg.sh`
Main script that performs the conversion of ELRA XML files to ELG-compatible XML files. It includes validation, namespace replacement, and transformation using XSLT.

### 2. `xsd-bulk-validator.sh`
A script to validate XML files in bulk using `xmllint`. It checks each XML file in a specified directory against the provided XSD schema.

### 3. `shellcheck-install.sh`
A utility script for installing `shellcheck`, a linting tool for shell scripts.

### 4. XSLT Transformation Files
- **`./rules/elra-to-elg-root.xsl`**: Handles the root-level transformation and namespace adjustments.
- **`./rules/elra-to-elg-body.xsl`**: Handles deeper transformations of XML structures specific to ELRA to ELG conversion.

## License
The scripts and stylesheets are licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. See the `LICENSE` file for more details.
