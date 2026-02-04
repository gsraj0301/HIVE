const mongoose = require('mongoose');

const officialReportSchema = new mongoose.Schema({
  reportId: { type: String, unique: true },
  
  // Spammer Info
  spammerPhoneNumber: String,
  spammerEmail: String,
  spammerName: String,
  
  // Collected Data
  spamType: String,
  reportedCount: { type: Number, default: 0 },
  victimCount: { type: Number, default: 0 },
  estimatedFinancialLoss: { type: Number, default: 0 },
  
  // Evidence
  spamMessages: [mongoose.Schema.Types.ObjectId],
  autoReplies: [mongoose.Schema.Types.ObjectId],
  callSimulations: [mongoose.Schema.Types.ObjectId],
  
  // Intelligence Summary
  operationPattern: String,
  targetedCountries: [String],
  targetedBanks: [String],
  commonScripts: [String],
  commonTechniques: [String],
  
  // Law Enforcement
  forwardedToAgencies: [
    {
      agency: String,
      forwardedAt: Date,
      referenceNumber: String,
      status: String
    }
  ],
  
  severity: { type: String, enum: ['Low', 'Medium', 'High', 'Critical'], default: 'Medium' },
  priority: { type: Number, default: 5 },
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('OfficialReport', officialReportSchema);
