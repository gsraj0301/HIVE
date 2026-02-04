const mongoose = require('mongoose');

const autoReplySchema = new mongoose.Schema({
  spamMessageId: { type: mongoose.Schema.Types.ObjectId, ref: 'SpamMessage' },
  replyContent: String,
  replyType: { type: String, enum: ['GENERIC', 'PERSONALIZED', 'FAKE_VICTIM'], default: 'PERSONALIZED' },
  
  // Engagement Tracking
  sentAt: Date,
  receivedAt: Date,
  opened: { type: Boolean, default: false },
  clicked: { type: Boolean, default: false },
  
  // Time Metrics
  timeWasted: { type: Number, default: 0 },
  followUpReplies: [
    {
      senderMessage: String,
      ourReply: String,
      timestamp: { type: Date, default: Date.now },
      duration: Number
    }
  ],
  
  // Intelligence
  extractedInfo: {
    spammerPatterns: [String],
    usedTools: [String],
    targetDemographics: [String],
    successRate: Number
  },
  
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('AutoReply', autoReplySchema);
