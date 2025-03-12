#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 -t API_TOKEN -n API_NAME -f SPEC_FILE" 1>&2
  echo "  -t API_TOKEN    Your WireMock API token"
  echo "  -n API_NAME     Name of the MockAPI to create"
  echo "  -f SPEC_FILE    Path to the OpenAPI specification file"
  echo ""
  echo "Example: $0 -t 98bc20ccccc7130cccccaa7cb276fe36 -n \"My Test API\" -f ./sampleOpenAPIspec.yaml"
  exit 1
}

# Parse command line arguments
while getopts ":t:n:f:" opt; do
  case $opt in
    t) API_TOKEN="$OPTARG" ;;
    n) API_NAME="$OPTARG" ;;
    f) SPEC_FILE="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
    :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
  esac
done

# Check if all required parameters are provided
if [ -z "$API_TOKEN" ] || [ -z "$API_NAME" ] || [ -z "$SPEC_FILE" ]; then
  echo "Error: All parameters are required."
  usage
fi

# Check if spec file exists
if [ ! -f "$SPEC_FILE" ]; then
  echo "Error: Specification file '$SPEC_FILE' not found."
  exit 1
fi

echo "Creating new MockAPI: '$API_NAME'..."

# Create a new MockAPI and store the response
RESPONSE=$(curl --silent --request POST \
  --url https://api.wiremock.cloud/v1/mock-apis \
  --header "Authorization: Token $API_TOKEN" \
  --header "Content-Type: application/json" \
  --data "{
    \"mockApi\": {
      \"name\": \"$API_NAME\",
      \"type\": \"openapi\"
    }
  }")

# Extract the mockApiId from the response using grep and cut
MOCK_API_ID=$(echo $RESPONSE | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

if [ -z "$MOCK_API_ID" ]; then
  echo "Error: Failed to extract mockApiId from response."
  echo "Response: $RESPONSE"
  exit 1
fi

echo "MockAPI created with ID: $MOCK_API_ID"

echo "Importing OpenAPI specification from '$SPEC_FILE'..."

# Import the OpenAPI specification
IMPORT_RESPONSE=$(curl --silent --request POST \
  --url "https://api.wiremock.cloud/v1/mock-apis/$MOCK_API_ID/imports" \
  --header "Authorization: Token $API_TOKEN" \
  --header "Content-Type: */*" \
  --data-binary "@$SPEC_FILE")

echo "Import response: $IMPORT_RESPONSE"

echo "Process completed successfully."