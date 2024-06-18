const express = require('express');
const axios = require('axios');
require('dotenv').config(); 

const app = express();
const port = 3000; 

app.use(express.json()); 

const apiKey = process.env.API_KEY;
const externalApiUrl = process.env.EXTERNAL_API_URL;

app.post('/', async (req, res) => {
  return res.status(401).json({ error: 'Nothing Here' });
})

app.get('/', async (req, res) => {
  return res.status(401).json({ error: 'Nothing Here' });
})

app.post('/processData', async (req, res) => {
  const { apiKey: incomingApiKey } = req.body;

  if (!incomingApiKey || incomingApiKey !== apiKey) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try 
  {
    const apiResponse = await axios.get(externalApiUrl);
    res.json(apiResponse.data);
  } 
  catch (error) {
    console.error('Error fetching data from external API:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server is running on Port ${port}`);
});
