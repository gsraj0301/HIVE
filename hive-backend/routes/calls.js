const express = require('express');
const router = express.Router();
const CallSimulation = require('../models/CallSimulation');

// GET /api/calls - Get all call simulations
router.get('/', async (req, res) => {
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
      data: calls.map(call => ({
        _id: call._id,
        scamType: call.scamType,
        conversationStages: call.conversation.length,
        userResponses: call.userResponses.length,
        estimatedDuration: call.estimatedDuration,
        techniquesUsed: call.techniquesUsed,
        createdAt: call.createdAt
      })),
      pagination: { total, skip: parseInt(skip), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/calls/:id - Get call details
router.get('/:id', async (req, res) => {
  try {
    const call = await CallSimulation.findById(req.params.id);
    if (!call) return res.status(404).json({ error: 'Call not found' });
    
    res.json({
      success: true,
      data: {
        _id: call._id,
        scamType: call.scamType,
        conversation: call.conversation,
        userResponses: call.userResponses,
        techniquesUsed: call.techniquesUsed,
        estimatedDuration: call.estimatedDuration,
        completionPercentage: Math.round(
          (call.userResponses.length / call.conversation.length) * 100
        ),
        createdAt: call.createdAt
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
