const { app, server, io } = require('./server');
const { sequelize } = require('./models');
const http = require('http');

// Check if PostgreSQL is available
let hasPostgreSQL = false;
try {
  const { Client } = require('pg');
  const client = new Client({
    connectionTimeoutMillis: 1000,
  });
  hasPostgreSQL = true;
} catch (e) {
  hasPostgreSQL = false;
}

// Test configuration
const testConfig = {
  port: 3001,
  testTimeout: 10000,
  dbTestTimeout: 15000
};

// Test results
const results = {
  database: null,
  server: null,
  api: null,
  socket: null,
  health: null
};

console.log('🧪 Starting Uber Clone Backend Tests...');
console.log('========================================');

/**
 * Test database connection
 */
const testDatabaseConnection = async () => {
  console.log('\n🔍 Testing Database Connection...');

  try {
    // Wait for database to be ready
    await new Promise(resolve => setTimeout(resolve, 2000));

    await sequelize.authenticate();
    console.log('✅ Database connection test: PASSED');
    results.database = true;

    // Test sync
    await sequelize.sync({ alter: true });
    console.log('✅ Database sync test: PASSED');
  } catch (error) {
    console.error('❌ Database connection test: FAILED');
    console.error('Error:', error.message);
    results.database = false;
  }
};

/**
 * Test server startup
 */
const testServerStartup = async () => {
  console.log('\n🔍 Testing Server Startup...');

  try {
    // Wait for server to start
    await new Promise(resolve => setTimeout(resolve, 3000));

    const response = await new Promise((resolve, reject) => {
      http.get('http://localhost:3000', (res) => {
        resolve(res.statusCode);
      }).on('error', (err) => {
        reject(err);
      });
    });

    if (response === 200) {
      console.log('✅ Server startup test: PASSED');
      results.server = true;
    } else {
      console.log('❌ Server startup test: FAILED (Status code:', response, ')');
      results.server = false;
    }
  } catch (error) {
    console.error('❌ Server startup test: FAILED');
    console.error('Error:', error.message);
    results.server = false;
  }
};

/**
 * Test API endpoints
 */
const testAPIEndpoints = async () => {
  console.log('\n🔍 Testing API Endpoints...');

  const http = require('http');
  const endpoints = [
    { path: '/api/health', method: 'GET' },
    { path: '/api/auth/demo/login/rider', method: 'POST' },
    { path: '/api/auth/demo/login/driver', method: 'POST' },
    { path: '/api/auth/demo/login/admin', method: 'POST' }
  ];

  let passed = 0;
  let failed = 0;

  for (const endpoint of endpoints) {
    try {
      const options = {
        hostname: 'localhost',
        port: 3000,
        path: endpoint.path,
        method: endpoint.method,
        headers: {
          'Content-Type': 'application/json'
        }
      };

      await new Promise((resolve, reject) => {
        const req = http.request(options, (res) => {
          if (res.statusCode >= 200 && res.statusCode < 300) {
            console.log(`✅ ${endpoint.method} ${endpoint.path}: PASSED`);
            passed++;
          } else {
            console.log(`❌ ${endpoint.method} ${endpoint.path}: FAILED (Status: ${res.statusCode})`);
            failed++;
          }
          resolve();
        });

        req.on('error', (err) => {
          console.log(`❌ ${endpoint.method} ${endpoint.path}: FAILED (Error: ${err.message})`);
          failed++;
          resolve();
        });

        req.end();
      });
    } catch (error) {
      console.log(`❌ ${endpoint.method} ${endpoint.path}: FAILED (Error: ${error.message})`);
      failed++;
    }
  }

  if (passed > 0) {
    results.api = true;
    console.log(`✅ API endpoints test: ${passed} passed, ${failed} failed`);
  } else {
    results.api = false;
    console.log(`❌ API endpoints test: ${passed} passed, ${failed} failed`);
  }
};

/**
 * Test Socket.io connection
 */
const testSocketConnection = async () => {
  console.log('\n🔍 Testing Socket.io Connection...');

  try {
    const Socket = require('socket.io-client');
    const socket = Socket.connect('http://localhost:3000', {
      transports: ['websocket'],
      timeout: 5000
    });

    const connected = await new Promise((resolve, reject) => {
      socket.on('connect', () => {
        console.log('✅ Socket.io connection test: PASSED');
        socket.disconnect();
        resolve(true);
      });

      socket.on('connect_error', (error) => {
        console.log('❌ Socket.io connection test: FAILED');
        console.error('Error:', error.message);
        resolve(false);
      });

      setTimeout(() => {
        socket.disconnect();
        resolve(false);
      }, 5000);
    });

    results.socket = connected;
  } catch (error) {
    console.error('❌ Socket.io connection test: FAILED');
    console.error('Error:', error.message);
    results.socket = false;
  }
};

/**
 * Test health endpoint
 */
const testHealthEndpoint = async () => {
  console.log('\n🔍 Testing Health Endpoint...');

  try {
    const http = require('http');

    const options = {
      hostname: 'localhost',
      port: 3000,
      path: '/api/health',
      method: 'GET'
    };

    const response = await new Promise((resolve, reject) => {
      const req = http.request(options, (res) => {
        let data = '';

        res.on('data', (chunk) => {
          data += chunk;
        });

        res.on('end', () => {
          try {
            const healthData = JSON.parse(data);
            console.log('✅ Health endpoint test: PASSED');
            console.log('  Status:', healthData.status);
            console.log('  Database:', healthData.services.database);
            console.log('  Socket:', healthData.services.socket);
            resolve(true);
          } catch (e) {
            console.log('❌ Health endpoint test: FAILED (Invalid JSON)');
            resolve(false);
          }
        });
      });

      req.on('error', (err) => {
        console.log('❌ Health endpoint test: FAILED');
        console.error('Error:', err.message);
        resolve(false);
      });

      req.end();
    });

    results.health = response;
  } catch (error) {
    console.error('❌ Health endpoint test: FAILED');
    console.error('Error:', error.message);
    results.health = false;
  }
};

/**
 * Run all tests
 */
const runTests = async () => {
  try {
    // Start the server (it's already started by requiring server.js)
    console.log('⏳ Starting tests...');

    // Run tests in sequence
    await testDatabaseConnection();
    await testServerStartup();
    await testAPIEndpoints();
    await testSocketConnection();
    await testHealthEndpoint();

    // Print summary
    console.log('\n========================================');
    console.log('📊 Test Summary:');
    console.log('========================================');
    console.log(`Database Connection: ${results.database ? '✅ PASSED' : '❌ FAILED'}`);
    console.log(`Server Startup: ${results.server ? '✅ PASSED' : '❌ FAILED'}`);
    console.log(`API Endpoints: ${results.api ? '✅ PASSED' : '❌ FAILED'}`);
    console.log(`Socket.io: ${results.socket ? '✅ PASSED' : '❌ FAILED'}`);
    console.log(`Health Endpoint: ${results.health ? '✅ PASSED' : '❌ FAILED'}`);

    const totalTests = Object.keys(results).length;
    const passedTests = Object.values(results).filter(r => r === true).length;
    const failedTests = totalTests - passedTests;

    console.log('\n📈 Overall Result:');
    console.log(`  Total Tests: ${totalTests}`);
    console.log(`  Passed: ${passedTests}`);
    console.log(`  Failed: ${failedTests}`);

    if (failedTests === 0) {
      console.log('\n🎉 All tests passed! Server is ready for production.');
      process.exit(0);
    } else {
      console.log('\n⚠️  Some tests failed. Please check the logs above.');
      process.exit(1);
    }
  } catch (error) {
    console.error('\n❌ Test execution failed:', error.message);
    process.exit(1);
  }
};

// Run tests
runTests();
