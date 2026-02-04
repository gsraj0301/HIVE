const express = require('express');
const router = express.Router();
const SpamMessage = require('../models/SpamMessage');

// GET /api/scammers - Get list of scammers
router.get('/', async (req, res) => {
  try {
    const { skip = 0, limit = 20 } = req.query;
    
    // Aggregate scammers by phone and email
    const scammers = await SpamMessage.aggregate([
      { $match: { isSuspicious: true } },
      {
        $group: {
          _id: {
            phone: { $arrayElemAt: ['$extractedPhoneNumbers', 0] },
            email: { $arrayElemAt: ['$extractedEmails', 0] }
          },
          count: { $sum: 1 },
          types: { $addToSet: '$spamType' },
          avgScore: { $avg: '$spamScore' },
          lastSeen: { $max: '$createdAt' }
        }
      },
      { $sort: { count: -1 } },
      { $skip: parseInt(skip) },
      { $limit: parseInt(limit) }
    ]);
    
    const total = await SpamMessage.countDocuments({ isSuspicious: true });
    
    res.json({
      success: true,
      data: scammers.map(scammer => ({
        id: scammer._id.phone || scammer._id.email,
        phone: scammer._id.phone || 'Not available',
        email: scammer._id.email || 'Not available',
        attackCount: scammer.count,
        threatTypes: scammer.types,
        riskScore: Math.round(scammer.avgScore),
        riskLevel: scammer.avgScore >= 70 ? 'Critical' : scammer.avgScore >= 50 ? 'High' : 'Medium',
        lastActivity: scammer.lastSeen
      })),
      pagination: { total, skip: parseInt(skip), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/scammers/:id - Get scammer details
router.get('/:id', async (req, res) => {
  try {
    const messages = await SpamMessage.find({
      $or: [
        { 'extractedPhoneNumbers': req.params.id },
        { 'extractedEmails': req.params.id },
        { 'sender': req.params.id }
      ]
    }).sort({ createdAt: -1 });
    
    if (messages.length === 0) {
      return res.status(404).json({ error: 'Scammer not found' });
    }
    
    const stats = {
      totalAttacks: messages.length,
      threatTypes: [...new Set(messages.map(m => m.spamType))],
      avgRiskScore: Math.round(messages.reduce((a, b) => a + b.spamScore, 0) / messages.length),
      recoveredPhones: [...new Set(messages.flatMap(m => m.extractedPhoneNumbers))],
      recoveredEmails: [...new Set(messages.flatMap(m => m.extractedEmails))],
      recoveredBanks: [...new Set(messages.flatMap(m => m.extractedBanks))],
      totalAmounts: messages.flatMap(m => m.extractedAmounts),
      urls: [...new Set(messages.flatMap(m => m.extractedUrls))],
      firstSeen: messages[messages.length - 1].createdAt,
      lastSeen: messages[0].createdAt
    };
    
    res.json({
      success: true,
      scammerId: req.params.id,
      stats,
      recentMessages: messages.slice(0, 5).map(m => ({
        id: m._id,
        type: m.spamType,
        content: m.content.substring(0, 100) + '...',
        score: m.spamScore,
        timestamp: m.createdAt
      }))
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
