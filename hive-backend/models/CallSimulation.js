const mongoose = require('mongoose');

const callSimulationSchema = new mongoose.Schema({
  spammerId: mongoose.Schema.Types.ObjectId,
  spammerPhoneNumber: String,
  
  // Call Details
  callStartTime: Date,
  callEndTime: Date,
  callDuration: { type: Number, default: 0 },
  recordingUrl: String,
  
  // Conversation
  conversationStages: [
    {
      stage: String,
      spammerMessage: String,
      ourResponse: String,
      audioUrl: String,
      timestamp: { type: Date, default: Date.now },
    }
  ],
  
  // Intelligence
  detectedTechniques: [String],
  scriptKeywords: [String],
  emotionalManipulationLevel: { type: Number, min: 0, max: 10, default: 0 },
  
  // Metrics
  totalTimeWasted: Number,
  conversationTurns: { type: Number, default: 0 },
  
  // Fake Info Collected
  fakeVictimInfo: {
    name: String,
    bankName: String,
    accountNumber: String,
    address: String
  },
  
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('CallSimulation', callSimulationSchema);
