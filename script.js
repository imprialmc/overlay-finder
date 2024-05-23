// JavaScript code to fetch packs.json and the data.json of each pack

// Function to fetch and process the packs.json file
async function fetchPacksJson() {
  try {
      // Fetch the packs.json file
      let response = await fetch('packs.json');

      // Check if the response is successful
      if (!response.ok) {
          throw new Error('Network response was not ok ' + response.statusText);
      }

      // Parse the JSON data
      let packs = await response.json();

      // Process each pack
      for (let pack of packs) {
          // Construct the path to the data.json file
          let dataJsonPath = `packs/${pack.pack}/data.json`;

          // Fetch and process the data.json file
          await fetchDataJson(dataJsonPath);
      }
  } catch (error) {
      // Handle any errors that occurred during the fetch
      console.error('There has been a problem with your fetch operation:', error);
  }
}

// Function to fetch and process a specific data.json file
async function fetchDataJson(dataJsonPath) {
  try {
      // Fetch the data.json file
      let response = await fetch(dataJsonPath);

      // Check if the response is successful
      if (!response.ok) {
          throw new Error('Network response was not ok ' + response.statusText);
      }

      // Get the text response
      let textData = await response.text();

      // Check if the response is empty
      if (!textData) {
          console.warn(`The file at ${dataJsonPath} is empty.`);
          return;
      }

      // Parse the JSON data
      let data = JSON.parse(textData);

      // Log the data to the console (or process it as needed)
      console.log(`Data from ${dataJsonPath}:`, data);
  } catch (error) {
      // Handle any errors that occurred during the fetch or JSON parsing
      console.error(`There has been a problem with your fetch operation for ${dataJsonPath}:`, error);
  }
}

// Call the function to fetch and process the packs.json file
fetchPacksJson();
