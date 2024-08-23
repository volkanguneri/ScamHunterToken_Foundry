// [1] ARGUMENT DECLARATION 

// Gets the contract address temporarily defined in request-config.js.
const contractAddress = args[0];

// [2] REQUEST CONTRACT VIA ETHERSCAN 

// HTTP request to get the contract if verified on Etherscan.
const etherscanResponse = await Functions.makeHttpRequest({ 
    url: `https://api-sepolia.etherscan.io/api?module=contract&action=getsourcecode&address=${contractAddress}&apikey=${secrets.etherscanAPIKey}`,
})

// Verify if the request failed
if (etherscanResponse.error) {
    throw new Error(`HTTP request failed`);
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
console.log(`🚀 ~ content of contract:`, contractContent);

// Return the aggregated content of the contract files
return Functions.encodeString(parsedSourceCode);
