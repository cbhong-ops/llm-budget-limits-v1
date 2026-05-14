// var input_price = context.getVariable('verifyapikey.VA-VerifyAPIKey.apiproduct.test_input_price_per_100M');
//var ops_input_price = context.getVariable('apiproduct.operation.attributes.input_price_per_100M');
//var ops_output_price = context.getVariable('apiproduct.operation.attributes.output_price_per_100M');

//context.setVariable('input_price', input_price);
//context.setVariable('ops_input_price', ops_input_price);
//context.setVariable('ops_output_price', ops_output_price);


// 1. Get JSON string data and the target model name to find
var jsonString = context.getVariable("verifyapikey.VA-VerifyAPIKey.__apigee_reserved_llm_operation_configs_attribute"); 
var targetModel = context.getVariable("target_model");
try {
    // Convert JSON string to JavaScript object array
    var dataArray = JSON.parse(jsonString);
    var targetAttributes = null;
    // 2. Iterate through the entire array to find the matching model
    for (var i = 0; i < dataArray.length; i++) {
        var item = dataArray[i];
        var operations = item.llmOperations;
        var isModelFound = false;
        
        // Iterate inside the llmOperations array and compare model values
        if (operations && operations.length > 0) {
            for (var j = 0; j < operations.length; j++) {
                if (operations[j].model === targetModel) {
                    isModelFound = true;
                    break; // Break inner loop
                }
            }
        }
        // If the desired model is found, save the item's attributes and break outer loop
        if (isModelFound) {
            targetAttributes = item.attributes;
            break; 
        }
    }
    var inputPrice = 0;
    var outputPrice = 0;
    // 3. Read the found attributes array and set only required values as Apigee variables
    if (targetAttributes) {
        for (var k = 0; k < targetAttributes.length; k++) {
            var attrName = targetAttributes[k].name;
            var attrValue = targetAttributes[k].value;
            
            // Extract only input_price_per_100M and output_price_per_100M and save to local variables
            if (attrName === 'input_price_per_100M') {
                inputPrice = parseFloat(attrValue);
                context.setVariable("model_attr." + attrName, attrValue);
            }
            if (attrName === 'output_price_per_100M') {
                outputPrice = parseFloat(attrValue);
                context.setVariable("model_attr." + attrName, attrValue);
            }
        }
        
        // Success flag
        context.setVariable("model_attr.found", "true");
        
    } else {
        // Handling when no matching model is found
        context.setVariable("model_attr.found", "false");
    }
    // 4. Read usageMetadata from Gemini Response and calculate price
    var responseContent = context.getVariable("response.content");
    if (responseContent) {
        var responseJson = JSON.parse(responseContent);
        var usage = responseJson.usageMetadata;
        
        if (usage) {
            var promptTokens = usage.promptTokenCount || 0;
            var candidatesTokens = usage.candidatesTokenCount || 0;
            var thoughtsTokens = usage.thoughtsTokenCount || 0; // For models that require thinking (reasoning tokens)

            // Price calculation (as requested, simply multiply and sum)
            var totalPrice = (promptTokens * inputPrice) + ((candidatesTokens + thoughtsTokens) * outputPrice);
            
            // Save to flow variable named token_price_per_100M
            // context.setVariable("token_price_per_100M", totalPrice);
            context.setVariable("token_price_per_100M", String(totalPrice));
            
            // Good to save individual token counts for debugging (optional)
            context.setVariable("promptTokens_count", promptTokens);
            context.setVariable("candidatesTokens_count", candidatesTokens);
            context.setVariable("thoughtsTokens_count", thoughtsTokens);
        }
    }
} catch (e) {
    // Protect against JSON parsing errors
    context.setVariable("model_attr.error", e.message);
}