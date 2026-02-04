const mongoose = require('mongoose');

const spamMessageSchema = new mongoose.Schema({
  messageType: { type: String, enum: ['EMAIL', 'SMS'], required: true },
  sender: {
    email: String,
    phoneNumber: String,
    name: String,
  },
  content: { type: String, required: true },
  subject: String,
  timestamp: { type: Date, default: Date.now },
  
  // Detection Results
  spamScore: { type: Number, min: 0, max: 100, default: 0 },
  spamType: String,
  keywords: [String],
  isSuspicious: { type: Boolean, default: false },
  
  // Intelligence Extracted
  extractedPhoneNumbers: [String],
  extractedEmails: [String],
  extractedBanks: [String],
  extractedAmounts: [String],
  extractedUrls: [String],
  
  // Engagement
  autoReplyId: mongoose.Schema.Types.ObjectId,
  replyCount: { type: Number, default: 0 },
  spammerEngagementTime: { type: Number, default: 0 },
  
  // Report
  reportedToOfficials: { type: Boolean, default: false },
  officialReportId: String,
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

spamMessageSchema.index({ spamType: 1, createdAt: -1 });
spamMessageSchema.index({ isSuspicious: 1 });

module.exports = mongoose.model('SpamMessage', spamMessageSchema);
