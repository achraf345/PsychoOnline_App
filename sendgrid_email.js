const sgMail = require('@sendgrid/mail');

sgMail.setApiKey('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');
async function sendValidationEmail(data) {
  if (!data) {
    console.log('No data provided for sending email.');
    return;
  }
  const clientEmail = data.clientEmail;
  const clientName = `${data.clientFirstName} ${data.clientLastName}`;
  const doctorName = data.doctorName;
  const problemDescription = data.problemDescription;
  const paymentType = data.paymentType;
  const meetingDate = data.meetingDate
    ? new Date(data.meetingDate).toDateString()
    : 'N/A';
  const selectedPeriod = data.selectedPeriod || 'N/A';
  const selectedTimeSlot = data.selectedTimeSlot || 'N/A';
  const msg = {
    to: clientEmail,
    from: 'achirachraf5@gmail.com', 
    subject: 'Your Demand Has Been Validated',
    text: `Dear ${clientName},

Your demand has been validated by Dr. ${doctorName}.

Details of your demand:
- Problem Description: ${problemDescription}
- Payment Type: ${paymentType}
- Meeting Date: ${meetingDate}
- Meeting Period: ${selectedPeriod}
- Meeting Time Slot: ${selectedTimeSlot}

Thank you for using our service.

Best regards,
Your Healthcare Team`,
  };

  try {
    await sgMail.send(msg);
    console.log('✅ Validation email sent to:', clientEmail);
  } catch (error) {
    console.error('❌ Error sending email:', error.response ? error.response.body : error.message);
  }
}

module.exports = { sendValidationEmail };
