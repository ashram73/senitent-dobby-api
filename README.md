Overview
-
The script creates an interactive chat session with Dobby-70B, a language model powered by the Fireworks API. It allows you to send multiple messages and get real-time responses from the model in a continuous loop. The script uses curl to interact with the API and jq to handle JSON responses.

Prerequisites:
-
To set up and run an interactive, chat session with the Dobby-70B language model from Sentient using the Fireworks API in the shell, follow the steps below. This guide assumes you are using a command-line interface (CLI) environment like a terminal and have basic knowledge of shell commands.

1-API Key: Ensure you have a valid API key from Fireworks.

2-curl: You'll use curl to make HTTP requests from the shell.

3-jq: Optional but useful for parsing JSON responses from the API.

Step 1: Set Up Your API Key
-
First, store your API key in an environment variable (this keeps it secure and avoids putting it directly into commands). You can add it to your shell profile (like ~/.bashrc or ~/.zshrc) to make it available in every session.

    export FIREWORKS_API_KEY="your-api-key-here"

    source ~/.bashrc  # or source ~/.zshrc for Zsh

Step 2: Make a Request to the Fireworks API
-
    The Fireworks API provides an endpoint for chat completions. We’ll use curl to interact with the API.
    
    Here’s a basic example of how to call the chat endpoint with a single user message.
    
    curl -X POST "https://api.fireworks.ai/inference/v1/chat/completions" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $FIREWORKS_API_KEY" \
    -d '{
      "model": "accounts/sentientfoundation/models/dobby-unhinged-llama-3-3-70b-new",
      "max_tokens": 16384,
      "top_p": 1,
      "top_k": 40,
      "presence_penalty": 0,
      "frequency_penalty": 0,
      "temperature": 0.6,
      "messages": [
        {
          "role": "user",
          "content": "Hello, how are you?"
        }
      ]
    }'

Step 3: Understand the Request Structure
-
POST request to the endpoint: https://api.fireworks.ai/inference/v1/chat/completions.

Authorization: The API key is included in the Authorization header.

Content-Type: Set to application/json since we're sending JSON data.

Model: The model is specified as accounts/sentientfoundation/models/dobby-unhinged-llama-3-3-70b-new.

Max Tokens: This is set to the maximum length of the response (16384 tokens in this case).

Top_p & Top_k: Sampling settings to influence the response variety.

Presence and Frequency Penalties: Set to 0 for no penalty on repetition.

Temperature: Set to 0.6, controlling response randomness.

Step 4: Handle API Response
-
The API will return a JSON response containing the model's reply. You can use jq to parse and display the response.

Example to print only the model's response:

        curl -X POST "https://api.fireworks.ai/inference/v1/chat/completions" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $FIREWORKS_API_KEY" \
        -d '{
          "model": "accounts/sentientfoundation/models/dobby-unhinged-llama-3-3-70b-new",
          "max_tokens": 16384,
          "top_p": 1,
          "top_k": 40,
          "presence_penalty": 0,
          "frequency_penalty": 0,
          "temperature": 0.6,
          "messages": [
            {
              "role": "user",
              "content": "Hello, how are you?"
            }
          ]
        }' | jq '.choices[0].message.content'
    
    Step 5: Interactive Chat Session
    -
    Interactive Chat Script:
    
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

Step 6: Running the Script
-
Save the script as dobby_chat.sh.

Make it executable:

    chmod +x dobby_chat.sh

Run the script:
-
    ./dobby_chat.sh

This setup provides a way to run an interactive chat session with Dobby-70B using Fireworks API and curl in the shell. The user can continuously send messages, and the model will respond based on the provided configurations.













