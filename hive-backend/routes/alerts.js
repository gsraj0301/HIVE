const express = require('express');
const router = express.Router();
const SpamMessage = require('../models/SpamMessage');

// GET /api/alerts - Get all alerts
router.get('/', async (req, res) => {
  try {
    const { skip = 0, limit = 20, severity } = req.query;
    
    let query = { isSuspicious: true };
    if (severity) query.spamScore = { $gte: severity };
    
    const alerts = await SpamMessage.find(query)
      .sort({ createdAt: -1 })
      .skip(parseInt(skip))
      .limit(parseInt(limit));
    
    const total = await SpamMessage.countDocuments(query);
    
    res.json({
      success: true,
      data: alerts.map(alert => ({
        _id: alert._id,
        type: alert.spamType,
        severity: alert.spamScore >= 70 ? 'Critical' : alert.spamScore >= 50 ? 'High' : 'Medium',
        message: alert.content.substring(0, 100) + '...',
        sender: alert.sender,
        score: alert.spamScore,
        timestamp: alert.createdAt
      })),
      pagination: { total, skip: parseInt(skip), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/alerts/:id - Get alert details
router.get('/:id', async (req, res) => {
  try {
    const alert = await SpamMessage.findById(req.params.id);
    if (!alert) return res.status(404).json({ error: 'Alert not found' });
    
    res.json({
      success: true,
      data: {
        _id: alert._id,
        type: alert.spamType,
        severity: alert.spamScore >= 70 ? 'Critical' : alert.spamScore >= 50 ? 'High' : 'Medium',
        content: alert.content,
        sender: alert.sender,
        score: alert.spamScore,
        extractedData: {
          phones: alert.extractedPhoneNumbers,
          emails: alert.extractedEmails,
          banks: alert.extractedBanks,
          amounts: alert.extractedAmounts,
          urls: alert.extractedUrls
        },
        timestamp: alert.createdAt
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
