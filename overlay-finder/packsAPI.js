// JavaScript code to fetch packs.json and data.json files

// Function to fetch packs.json
async function fetchPacksJson() {
    try {
        let response = await fetch('packs.json');
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        return await response.json();
    } catch (error) {
        console.error('There has been a problem with your fetch operation:', error);
        return [];
    }
}

// Function to fetch data.json of a specific pack
async function fetchDataJson(packName) {
    try {
        let response = await fetch(`packs/${packName}/data.json`);
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        let textData = await response.text();
        if (!textData) {
            console.warn(`The file for ${packName} is empty.`);
            return null;
        }
        return JSON.parse(textData);
    } catch (error) {
        console.error(`There has been a problem with your fetch operation for ${packName}:`, error);
        return null;
    }
}

// Function to fetch all data.json files of packs
async function fetchAllDataJson() {
    try {
        let packs = await fetchPacksJson();
        let allData = [];
        for (let pack of packs) {
            let data = await fetchDataJson(pack.pack);
            if (data) {
                allData.push(data);
            }
        }
        return allData;
    } catch (error) {
        console.error('There has been a problem with your fetch operation:', error);
        return [];
    }
}

// Function to fetch specified number of random data.json files
async function fetchRandomDataJson(numPacksToFetch) {
    try {
        let packs = await fetchPacksJson();

        // Shuffle the packs array
        packs = shuffleArray(packs);

        // Get the specified number of random packs
        let randomPacks = [];
        for (let i = 0; i < Math.min(numPacksToFetch, packs.length); i++) {
            let pack = packs[i];
            let data = await fetchDataJson(pack.pack);
            if (data) {
                randomPacks.push(data);
            }
        }
        return randomPacks;
    } catch (error) {
        console.error('There has been a problem with your fetch operation:', error);
        return [];
    }
}

// Function to shuffle an array (Fisher-Yates shuffle algorithm)
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

// Function to search packs based on name or tags
async function searchPacks(searchTerm) {
    try {
        let packs = await fetchPacksJson();
        let searchData = [];
        for (let pack of packs) {
            let data = await fetchDataJson(pack.pack);
            if (data && (pack.pack.toLowerCase().includes(searchTerm) || hasTag(data.tags, searchTerm))) {
                searchData.push(data);
            }
        }
        return searchData;
    } catch (error) {
        console.error('There has been a problem with your search operation:', error);
        return [];
    }
}

// Function to check if tags array contains a specific tag
function hasTag(tags, searchTerm) {
    return tags.some(tag => tag.toLowerCase().includes(searchTerm));
}
