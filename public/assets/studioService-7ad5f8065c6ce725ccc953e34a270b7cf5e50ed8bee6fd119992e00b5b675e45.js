// Fetching data from the API and storing it in a variable
fetch('https://example.com/api/studios')
  .then(response => response.json())  // Parse the JSON response
  .then(data => {
    // Store the data in a variable
    const studiosData = data;

    // Example: Extract and display the relevant information (name, size, price)
    const studioList = studiosData.studiolist;
    studioList.forEach(studio => {
      const studioName = studio.m_stu.studio_name;
      const size = studio.m_stu.size;
      const price = studio.m_price0;

      console.log(`Studio Name: ${studioName}`);
      console.log(`Size: ${size} sqm`);
      console.log(`Price: ¥${price}`);
      console.log('---------------------------');
    });
  })
  .catch(error => {
    console.error('Error fetching data:', error);
  });
