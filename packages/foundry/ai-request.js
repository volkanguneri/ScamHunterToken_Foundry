// [1] ARGUMENT DECLARATION 

// Gets the contract address temporarily defined in request-config.js.
const contractAddress = args[0];

// [2] REQUEST CONTRACT VIA ETHERSCAN 

// HTTP request to get the contract if verified on Etherscan.
const etherscanResponse = await Functions.makeHttpRequest({ 
    url: `https://api-sepolia.etherscan.io/api?module=contract&action=getsourcecode&address=${contractAddress}&apikey=${secrets.etherscanAPIKey}`,
})

// console.log(`etherscanResponse: ${etherscanResponse}`)

// Check if the HTTP request was successful
if (etherscanResponse.error) {
    throw new Error(`HTTP request failed: ${etherscanResponse.error}`);
}

// Check if data and result are defined in the response
if (!etherscanResponse.data || !etherscanResponse.data.result || etherscanResponse.data.result.length === 0) {
    throw new Error('Invalid response from Etherscan API or contract not found.');
}

// Retrieve the content of the response
const sourceCodeJson = etherscanResponse.data.result[0].SourceCode;

// Parsing the JSON if necessary
let parsedSourceCode;
try {
    // Remove double curly braces if present and parse the JSON
    parsedSourceCode = JSON.parse(sourceCodeJson.replace(/{{/g, '{').replace(/}}/g, '}'));
} catch (error) {
    console.error("Error parsing the source code JSON:", error);
}

// Declare variable to store the combined content of all contract files
let contractContent = "";

// Check if the sources object is present
if (parsedSourceCode && parsedSourceCode.sources) {
    // Iterate through each file in the sources object
    for (const [filePath, fileDetails] of Object.entries(parsedSourceCode.sources)) {
        // Access the content of each file and concatenate it
        contractContent += fileDetails.content + '\n'; // Append content with newline
    }
}

// Log the aggregated content (for debugging purposes)
// console.log(`🚀 ~ content of contract:`, contractContent);


// [3] PROMPT ENGINEERING //
const prompt = `Analyse the smart contract in one sentence tell what is the risk for security if interacted with: ${contractContent}`;
// const prompt = `Analyse the smart contract in one sentence tell what is the risk for security if interacted with: //SPDX-License-Identifier: MIT
// pragma solidity >=0.8.0 <0.9.0;

// contract Basic {
//     uint256 numberA = 1;
//     uint256 numberB = 2;

//     constructor() {}

//     function total() external view returns (uint256) {
//         return (numberA + numberB);
//     }
// }
// `;

// [4] I DATA REQUEST //
let openAIRequest;
try {
  // Ensure the API key is available
  if (!secrets.openaiAPIKey) {
    throw new Error("OpenAI API key is missing. Please ensure it is set correctly.");
  }


  // Make the OpenAI API request
  openAIRequest = await Functions.makeHttpRequest({
    url: `https://api.openai.com/v1/chat/completions`,
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${secrets.openaiAPIKey}`,
    },
    data: {
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "You are a smart contract auditor",
        },
        {
          role: "user",
          content: prompt,
        },
      ],
    },
    timeout: 10000,
    responseType: "json",
  });
  console.log("🚀 ~ openAIRequest:", openAIRequest)

  // Log the entire response for debugging purposes
//   console.log(`OpenAI API response: ${JSON.stringify(openAIRequest.data, null, 2)}`);

  // Check if the data is present and in the expected format
  if (!openAIRequest.data || !openAIRequest.data.choices || openAIRequest.data.choices.length === 0) {
    throw new Error("Invalid response from OpenAI API: 'choices' array is missing or empty.");
  }

  // Extract the result from the response
  const stringResult = openAIRequest.data.choices[0].message.content.trim();
  const result = stringResult.toString();

  console.log(`OpenAI security analysis of the contract address ${contractAddress} is: ${result}`);
  return Functions.encodeString(result || "Failed");

} catch (error) {
  console.error("Error during the OpenAI request process:", error);
  return Functions.encodeString("Failed to fetch openAi request response");
}

// // [1] ARGUMENT DECLARATION
// const contractAddress = args[0];

// // [2] REQUEST CONTRACT VIA ETHERSCAN
// const etherscanResponse = await Functions.makeHttpRequest({
//     url: `https://api-sepolia.etherscan.io/api?module=contract&action=getsourcecode&address=${contractAddress}&apikey=${secrets.etherscanAPIKey}`,
// });

// if (etherscanResponse.error) {
//     throw new Error(`HTTP request failed: ${etherscanResponse.error}`);
// }

// if (!etherscanResponse.data || !etherscanResponse.data.result || etherscanResponse.data.result.length === 0) {
//     throw new Error('Invalid response from Etherscan API or contract not found.');
// }

// const sourceCodeJson = etherscanResponse.data.result[0].SourceCode;

// // Parsing the JSON if necessary
// let parsedSourceCode;
// try {
//     parsedSourceCode = JSON.parse(sourceCodeJson.replace(/{{/g, '{').replace(/}}/g, '}'));
// } catch (error) {
//     console.error("Error parsing the source code JSON:", error);
// }

// // Aggregating the content of all contract files
// let contractContent = "";
// if (parsedSourceCode && parsedSourceCode.sources) {
//     for (const [filePath, fileDetails] of Object.entries(parsedSourceCode.sources)) {
//         contractContent += fileDetails.content + '\n';
//     }
// }

// // [3] SPLITTING THE CONTRACT CONTENT INTO SMALLER CHUNKS
// const chunkSize = 1024; // Adjust the chunk size based on the API's input limit
// const chunks = [];
// for (let i = 0; i < contractContent.length; i += chunkSize) {
//     chunks.push(contractContent.slice(i, i + chunkSize));
// }

// // [4] I DATA REQUEST //
// let results = [];

// try {
//     if (!secrets.openaiAPIKey) {
//         throw new Error("OpenAI API key is missing. Please ensure it is set correctly.");
//     }

//     for (const chunk of chunks) {
//         const openAIRequest = await Functions.makeHttpRequest({
//             url: `https://api.openai.com/v1/chat/completions`,
//             method: "POST",
//             headers: {
//                 "Content-Type": "application/json",
//                 Authorization: `Bearer ${secrets.openaiAPIKey}`,
//             },
//             data: {
//                 model: "gpt-3.5-turbo",
//                 messages: [
//                     {
//                         role: "system",
//                         content: "You are a smart contract auditor",
//                     },
//                     {
//                         role: "user",
//                         content: `Analyze the following smart contract code and report any security threats:\n\n${chunk}`,
//                     },
//                 ],
//             },
//             timeout: 10000,
//             responseType: "json",
//         });

//         if (openAIRequest.data && openAIRequest.data.choices && openAIRequest.data.choices.length > 0) {
//             results.push(openAIRequest.data.choices[0].message.content.trim());
//         } else {
//             throw new Error("Invalid response from OpenAI API: 'choices' array is missing or empty.");
//         }
//     }

//     const finalResult = results.join("\n");
//     console.log(`OpenAI security analysis of the contract address ${contractAddress} is:\n${finalResult}`);
//     return Functions.encodeString(finalResult || "Failed");

// } catch (error) {
//     console.error("Error during the OpenAI request process:", error);
//     return Functions.encodeString("Failed to fetch openAi request response");
// }
