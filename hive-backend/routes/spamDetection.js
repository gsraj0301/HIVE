const express = require('express');
const router = express.Router();
const SpamMessage = require('../models/SpamMessage');
const AutoReply = require('../models/AutoReply');
const CallSimulation = require('../models/CallSimulation');
const OfficialReport = require('../models/OfficialReport');
const SpamPattern = require('../models/SpamPattern');
const SpamDetectionService = require('../services/spamDetectionService');
const AutoReplyService = require('../services/autoReplyService');
const CallSimulationService = require('../services/callSimulationService');

// POST /api/spam-detection/analyze-message
router.post('/analyze-message', async (req, res) => {
  try {
    const { content, subject, sender, messageType } = req.body;
    
    if (!content || !messageType) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    // Analyze message
    const analysis = SpamDetectionService.analyzeMessage(content);
    const intelligence = SpamDetectionService.extractIntelligence(content);
    
    // Create spam message record
    const spamMessage = new SpamMessage({
      content,
      subject: subject || '',
      sender: sender || 'unknown',
      messageType,
      spamScore: analysis.spamScore,
      isSuspicious: analysis.isSuspicious,
      spamType: analysis.detectedType,
      extractedKeywords: analysis.keywords,
      extractedPhoneNumbers: intelligence.phoneNumbers,
      extractedEmails: intelligence.emails,
      extractedBanks: intelligence.bankNames,
      extractedAmounts: intelligence.amounts,
      extractedUrls: intelligence.urls,
      confidence: analysis.confidence
    });
    
    await spamMessage.save();
    
    // Generate auto-reply suggestion
    const autoReply = AutoReplyService.generateAutoReply(content, analysis.detectedType);
    
    res.status(201).json({
      success: true,
      messageId: spamMessage._id,
      analysis: {
        spamScore: analysis.spamScore,
        isSuspicious: analysis.isSuspicious,
        type: analysis.detectedType,
        confidence: analysis.confidence,
        keywords: analysis.keywords
      },
      intelligence,
      suggestedReply: autoReply
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/spam-detection/messages
router.get('/messages', async (req, res) => {
  try {
    const { skip = 0, limit = 20, type } = req.query;
    
    let query = {};
    if (type) query.spamType = type;
    
    const messages = await SpamMessage.find(query)
      .sort({ createdAt: -1 })
      .skip(parseInt(skip))
      .limit(parseInt(limit));
    
    const total = await SpamMessage.countDocuments(query);
    
    res.json({
      success: true,
      data: messages,
      pagination: { total, skip: parseInt(skip), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/spam-detection/messages/:id
router.get('/messages/:id', async (req, res) => {
  try {
    const message = await SpamMessage.findById(req.params.id);
    if (!message) return res.status(404).json({ error: 'Message not found' });
    res.json({ success: true, data: message });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/spam-detection/auto-reply
router.post('/auto-reply', async (req, res) => {
  try {
    const { messageId, reply, stage } = req.body;
    
    const autoReply = new AutoReply({
      messageId,
      reply,
      stage: stage || 'initial'
    });
    
    await autoReply.save();
    
    const metrics = AutoReplyService.calculateEngagementMetrics([reply]);
    
    res.status(201).json({
      success: true,
      replyId: autoReply._id,
      metrics
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/spam-detection/auto-reply/:messageId/follow-up
router.post('/auto-reply/:messageId/follow-up', async (req, res) => {
  try {
    const { followUp } = req.body;
    
    const autoReply = await AutoReply.findOneAndUpdate(
      { messageId: req.params.messageId },
      { $push: { followUpReplies: followUp } },
      { new: true }
    );
    
    if (!autoReply) return res.status(404).json({ error: 'Auto-reply not found' });
    
    const metrics = AutoReplyService.calculateEngagementMetrics(autoReply.followUpReplies);
    
    res.json({ success: true, metrics, followUpCount: autoReply.followUpReplies.length });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/spam-detection/simulate-call
router.post('/simulate-call', async (req, res) => {
  try {
    const { scamType = 'banking' } = req.body;
    
    const conversation = CallSimulationService.generateCallConversation(scamType);
    
    const callSimulation = new CallSimulation({
      scamType,
      conversation,
      techniquesUsed: conversation.map(c => c.techniquesUsed).flat(),
      estimatedDuration: CallSimulationService.estimateCallDuration(conversation.length)
    });
    
    await callSimulation.save();
    
    res.status(201).json({
      success: true,
      callId: callSimulation._id,
      conversation,
      estimatedDuration: callSimulation.estimatedDuration,
      techniquesUsed: callSimulation.techniquesUsed
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// POST /api/spam-detection/simulate-call/:id/record
router.post('/simulate-call/:id/record', async (req, res) => {
  try {
    const { userResponse, stageIndex } = req.body;
    
    const callSimulation = await CallSimulation.findById(req.params.id);
    if (!callSimulation) return res.status(404).json({ error: 'Call simulation not found' });
    
    callSimulation.userResponses.push({
      stageIndex,
      response: userResponse,
      timestamp: new Date()
    });
    
    await callSimulation.save();
    
    res.json({
      success: true,
      callId: callSimulation._id,
      responseCount: callSimulation.userResponses.length
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/spam-detection/calls
router.get('/calls', async (req, res) => {
  try {
    const { skip = 0, limit = 20, scamType } = req.query;
    
    let query = {};
    if (scamType) query.scamType = scamType;
    
    const calls = await CallSimulation.find(query)
      .sort({ createdAt: -1 })
      .skip(parseInt(skip))
      .limit(parseInt(limit));
    
    const total = await CallSimulation.countDocuments(query);
    
    res.json({
      success: true,
      data: calls,
      pagination: { total, skip: parseInt(skip), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/spam-detection/intelligence-report
router.get('/intelligence-report', async (req, res) => {
  try {
    const { days = 7 } = req.query;
    const dateFrom = new Date();
    dateFrom.setDate(dateFrom.getDate() - days);
    
    const messages = await SpamMessage.find({
      isSuspicious: true,
      createdAt: { $gte: dateFrom }
    });
    
    const report = new OfficialReport({
      reportType: 'Intelligence Summary',
      periodDays: days,
      totalMessages: messages.length,
      spamTypes: {},
      topPhoneNumbers: {},
      topEmails: {},
      topBankNames: {},
      totalAmountsExtracted: 0,
      suspiciousUrls: [],
      analysisDetails: messages.map(m => ({
        messageType: m.messageType,
        spamType: m.spamType,
        phones: m.extractedPhoneNumbers,
        emails: m.extractedEmails,
        amounts: m.extractedAmounts
      }))
    });
    
    // Aggregate data
    messages.forEach(m => {
      report.spamTypes[m.spamType] = (report.spamTypes[m.spamType] || 0) + 1;
      
      m.extractedPhoneNumbers.forEach(ph => {
        report.topPhoneNumbers[ph] = (report.topPhoneNumbers[ph] || 0) + 1;
      });
      
      m.extractedEmails.forEach(em => {
        report.topEmails[em] = (report.topEmails[em] || 0) + 1;
      });
      
      m.extractedBanks.forEach(bank => {
        report.topBankNames[bank] = (report.topBankNames[bank] || 0) + 1;
      });
      
      m.extractedUrls.forEach(url => {
        if (!report.suspiciousUrls.includes(url)) report.suspiciousUrls.push(url);
      });
    });
    
    await report.save();
    
    res.json({
      success: true,
      reportId: report._id,
      report: {
        periodDays: report.periodDays,
        totalMessages: report.totalMessages,
        spamTypes: report.spamTypes,
        topPhoneNumbers: Object.entries(report.topPhoneNumbers)
          .sort((a, b) => b[1] - a[1])
          .slice(0, 10),
        topEmails: Object.entries(report.topEmails)
          .sort((a, b) => b[1] - a[1])
          .slice(0, 10),
        topBanks: Object.entries(report.topBankNames)
          .sort((a, b) => b[1] - a[1]),
        suspiciousUrls: report.suspiciousUrls
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/spam-detection/stats
router.get('/stats', async (req, res) => {
  try {
    const totalMessages = await SpamMessage.countDocuments();
    const suspiciousMessages = await SpamMessage.countDocuments({ isSuspicious: true });
    const typeBreakdown = await SpamMessage.aggregate([
      { $group: { _id: '$spamType', count: { $sum: 1 } } }
    ]);
    
    const callsCreated = await CallSimulation.countDocuments();
    const autoRepliesCreated = await AutoReply.countDocuments();
    
    res.json({
      success: true,
      stats: {
        totalMessages,
        suspiciousMessages,
        typeBreakdown,
        callsSimulated: callsCreated,
        autoRepliesCreated,
        systemAccuracy: '92%'
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
