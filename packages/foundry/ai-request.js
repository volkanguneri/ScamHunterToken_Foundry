// [1] ARGUMENT DECLARATION //

// gets: token id for requested data.
const CONTRACT_ADDRESS = args[0] // --------------> |   bitcoin

// [2] REQUEST PRICES //

// constructs: an HTTP request for prices using Functions.
const contractRequest = await Functions.makeHttpRequest({ 
    url: `https://api-sepolia.etherscan.io/api?module=contract&action=getsourcecode&address=${CONTRACT_ADDRESS}&apikey=${secrets.etherscanAPIKey}`,
})

// executes: request then waits for the sorted response.
const contractResponse = await contractRequest.data.data.sort(
    // sorts: time (descending) to get the most recent prices.
    function(a, b) {
        return b.time - a.time
    }
)

// [3] RESPONSE HANDLING //

let contract = ""

// // gets: historical prices from the response
// for (let i=0; i<Number(HISTORICAL_DAYS); i++) {
//     // then: pushes them into the price array.
//         prices.push(priceResponse[i].priceUsd)
// }

// [4] PROMPT ENGINEERING //

const prompt = 
`Historical Data: ${prices}. Based off the historical data, use a ${FORECAST_METHOD} forecast to predict the price at the next timestamp in the time series.
No explanation. Only report a float number with no dollar sign and no context.`

// [5] AI DATA REQUEST //

// requests: OpenAI API using Functions
const openAIRequest = await Functions.makeHttpRequest({
    // url: URL of the API endpoint (required)
    url: `https://api.openai.com/v1/chat/completions`,
    // defaults to 'GET' (optional)
    method: "POST", 
    // headers: supplied as an object (optional)
    headers: { 
    "Content-Type": "application/json",
        "Authorization": `Bearer ${secrets.apiKey}`
    },
    // defines: data payload (request body as an object).
    data: {
        // AI model to use
        "model": "gpt-3.5-turbo",
        // messages: array of messages to send to the model
        "messages": [
        {
            // role: role of the message sender (either "user" or "system")
            "role": "system",
            // content: message content (required)
            "content": "You are forecasting the price of a token."
        },
        {
            "role": "user",
            "content": prompt
        }
    ]},
    // timeout: maximum request duration in ms (optional)
    timeout: 10_000,
    // maxTokens: maximum number of tokens to spend on the request (optional)
    maxTokens: 100,
    // responseType: expected response type (optional, defaults to 'json')
    responseType: "json"
})

const response = await openAIRequest

// finds: the response and returns the result (as a string).
const stringResult = response.data?.choices[0].message.content

// note: if your result is a really small price, then update to your desired precision.
const result = Number(stringResult).toFixed(PRECISION).toString()

console.log(`${FORECAST_METHOD} price forecast: %s`, stringResult)

return Functions.encodeString(result || "Failed")