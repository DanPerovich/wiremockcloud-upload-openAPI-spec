# WireMock API Creation Script

A bash script for creating WireMock Cloud mock APIs and importing OpenAPI specifications using the WireMock Cloud API.

## Overview

This script automates two common tasks when working with WireMock Cloud:
1. Creating a new mock API
2. Importing an OpenAPI specification into the newly created mock API

The script handles the process of extracting the mock API ID from the creation response and using it for the import operation, eliminating manual steps in the workflow.

## Prerequisites

- Bash shell
- cURL installed
- WireMock Cloud API token
- OpenAPI specification file

## Installation

1. Download the script from GitHub:
   ```bash
   curl -O https://raw.githubusercontent.com/DanPerovich/wiremockcloud-upload-openAPI-spec/main/uploadOpenAPIspec.sh
   ```

2. Make it executable:
   ```bash
   chmod +x uploadOpenAPIspec.sh
   ```

## Usage

Run the script with the following required parameters:

```bash
./uploadOpenAPIspec.sh -t API_TOKEN -n API_NAME -f SPEC_FILE
```

Where:
- `-t API_TOKEN`: Your WireMock Cloud API token
- `-n API_NAME`: Name for the mock API to be created
- `-f SPEC_FILE`: Path to your OpenAPI specification file

### Example

```bash
./uploadOpenAPIspec.sh -t 98bc20ccccc7130cccccaa7cb276fe36 -n "Payment Processing API" -f ./specs/payment-api.yaml
```

## Response

The script will provide feedback at each step:

1. Confirmation of mock API creation with the assigned ID
2. Response from the import operation
3. Final success message upon completion

## Error Handling

The script includes error handling for common issues:
- Missing required parameters
- Non-existent specification file
- Failed API responses

## Security Notes

- Your API token is sensitive information. Consider storing it in an environment variable or secure location instead of passing it directly in the command line.
- The script does not store or log your API token beyond the immediate execution context.

## API Documentation

For more information about the WireMock Cloud API, refer to the official documentation:
[WireMock API Documentation](https://docs.wiremock.io/api-reference)