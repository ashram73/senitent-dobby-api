#!/bin/bash

# Ensure API_KEY is set
if [ -z "$FIREWORKS_API_KEY" ]; then
  echo "API key is not set. Please set the FIREWORKS_API_KEY environment variable."
  exit 1
fi

# Start the chat session with an initial message
echo "Starting chat session. Type 'exit' to quit."

# Initialize an empty array for storing conversation messages
messages="[]"

while true; do
  # Prompt user for input
  read -p "You: " user_input

  # Exit condition
  if [[ "$user_input" == "exit" ]]; then
    echo "Ending session."
    break
  fi

  # Add user message to messages array
  messages=$(echo $messages | jq ". + [{\"role\": \"user\", \"content\": \"$user_input\"}]")

  # Call the API with the updated messages
  response=$(curl -s -X POST "https://api.fireworks.ai/inference/v1/chat/completions" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $FIREWORKS_API_KEY" \
    -d "{
      \"model\": \"accounts/sentientfoundation/models/dobby-unhinged-llama-3-3-70b-new\",
      \"max_tokens\": 16384,
      \"top_p\": 1,
      \"top_k\": 40,
      \"presence_penalty\": 0,
      \"frequency_penalty\": 0,
      \"temperature\": 0.6,
      \"messages\": $messages
    }")

  # Extract and display the model's reply
  reply=$(echo $response | jq -r '.choices[0].message.content')
  echo "Dobby: $reply"

  # Add model's response to the conversation history
  messages=$(echo $messages | jq ". + [{\"role\": \"assistant\", \"content\": \"$reply\"}]")
done
