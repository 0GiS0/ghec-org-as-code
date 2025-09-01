const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    service: '${{values.name}}',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// API routes
app.get('/api/hello', (req, res) => {
  res.json({
    message: 'Hello from ${{values.name}}!',
    timestamp: new Date().toISOString()
  });
});

app.get('/api/status', (req, res) => {
  res.json({
    service: '${{values.name}}',
    status: 'running',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.originalUrl} not found`
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 ${{values.name}} server running on port ${PORT}`);
  console.log(`📋 Health check: http://localhost:${PORT}/health`);
  console.log(`🔧 API endpoints: http://localhost:${PORT}/api/hello`);
});

module.exports = app;