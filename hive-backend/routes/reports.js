const express = require('express');
const router = express.Router();
const OfficialReport = require('../models/OfficialReport');

// POST /api/reports - Create new report
router.post('/', async (req, res) => {
  try {
    const { reportType, analysisDetails, periodDays } = req.body;
    
    const report = new OfficialReport({
      reportType: reportType || 'Intelligence Summary',
      periodDays: periodDays || 7,
      analysisDetails: analysisDetails || [],
      totalMessages: analysisDetails?.length || 0
    });
    
    await report.save();
    
    res.status(201).json({
      success: true,
      reportId: report._id,
      message: 'Report created successfully'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/reports - List all reports
router.get('/', async (req, res) => {
  try {
    const { skip = 0, limit = 20 } = req.query;
    
    const reports = await OfficialReport.find()
      .sort({ createdAt: -1 })
      .skip(parseInt(skip))
      .limit(parseInt(limit));
    
    const total = await OfficialReport.countDocuments();
    
    res.json({
      success: true,
      data: reports.map(r => ({
        _id: r._id,
        reportType: r.reportType,
        periodDays: r.periodDays,
        totalMessages: r.totalMessages,
        createdAt: r.createdAt
      })),
      pagination: { total, skip: parseInt(skip), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// GET /api/reports/:id - Get report details
router.get('/:id', async (req, res) => {
  try {
    const report = await OfficialReport.findById(req.params.id);
    if (!report) return res.status(404).json({ error: 'Report not found' });
    
    res.json({
      success: true,
      data: {
        _id: report._id,
        reportType: report.reportType,
        periodDays: report.periodDays,
        totalMessages: report.totalMessages,
        analysisDetails: report.analysisDetails,
        createdAt: report.createdAt
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
