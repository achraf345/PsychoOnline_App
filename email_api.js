const express = require('express');
const bodyParser = require('body-parser');
const { sendValidationEmail } = require('./sendgrid_email');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

app.post('/send-validation-email', async (req, res) => {
  const data = req.body;

  try {
    await sendValidationEmail(data);
    res.status(200).json({ message: 'Validation email sent successfully' });
  } catch (error) {
    console.error('Error sending validation email:', error);
    res.status(500).json({ error: 'Failed to send validation email' });
  }
});

app.listen(port, () => {
  console.log(`Email API server running on port ${port}`);
});
