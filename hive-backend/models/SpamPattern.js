const mongoose = require('mongoose');

const spamPatternSchema = new mongoose.Schema({
  pattern: String,
  patternType: String,
  
  // Statistics
  detectionCount: { type: Number, default: 0 },
  successRate: { type: Number, default: 0 },
  averageAmountLost: { type: Number, default: 0 },
  
  // Geographic
  commonCountries: [String],
  commonLanguages: [String],
  
  // Temporal
  mostActiveHours: [Number],
  mostActiveDays: [String],
  
  // AI Training Data
  keywords: [String],
  phrasing: [String],
  
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('SpamPattern', spamPatternSchema);
