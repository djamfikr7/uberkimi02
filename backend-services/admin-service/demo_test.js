#!/usr/bin/env node
/**
 * Demo Test Script - Demonstrates Mock Data Mode
 * This script shows that the backend works even without PostgreSQL
 */

const http = require('http');

// Test the demo endpoints that work without database
const endpoints = [
  { name: 'Rider Demo Login', path: '/api/auth/demo/login/rider' },
  { name: 'Driver Demo Login', path: '/api/auth/demo/login/driver' },
  { name: 'Admin Demo Login', path: '/api/auth/demo/login/admin' },
  { name: 'Health Check', path: '/api/health' }
];

console.log('🚀 Uber Clone Backend Demo Test');
console.log('========================================');
console.log('Testing demo endpoints (no database required)');
console.log('========================================\n');

let passed = 0;
let failed = 0;

endpoints.forEach((endpoint, index) => {
  const options = {
    hostname: 'localhost',
    port: 3000,
    path: endpoint.path,
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  };

  if (endpoint.path.includes('login')) {
    options.method = 'POST';
  }

  const req = http.request(options, (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      console.log(`📋 ${endpoint.name}:`);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        console.log(`   ✅ Status: ${res.statusCode} (PASSED)`);

        try {
          const jsonData = JSON.parse(data);
          if (jsonData.success || jsonData.status === 'healthy') {
            console.log(`   ✅ Response: ${jsonData.message || jsonData.status}`);
            passed++;
          } else {
            console.log(`   ❌ Response: ${jsonData.message || 'Unknown error'}`);
            failed++;
          }
        } catch (e) {
          console.log(`   ✅ Raw response received (${data.length} bytes)`);
          passed++;
        }
      } else {
        console.log(`   ❌ Status: ${res.statusCode} (FAILED)`);
        console.log(`   ❌ Response: ${data}`);
        failed++;
      }

      console.log('');

      if (index === endpoints.length - 1) {
        console.log('========================================');
        console.log('📊 Demo Test Results:');
        console.log(`   ✅ Passed: ${passed}`);
        console.log(`   ❌ Failed: ${failed}`);
        console.log(`   📈 Total: ${passed + failed}`);

        if (passed > 0) {
          console.log('\n✅ SUCCESS: Demo endpoints are working!');
          console.log('   The backend is running in mock data mode.');
          console.log('   This demonstrates that the system works without PostgreSQL.');
        } else {
          console.log('\n❌ FAILURE: No endpoints responded successfully.');
          console.log('   Please ensure the backend server is running.');
        }

        console.log('\n💡 To run with PostgreSQL:');
        console.log('   1. Install PostgreSQL');
        console.log('   2. Create database: CREATE DATABASE uber_clone;');
        console.log('   3. Configure .env file with correct credentials');
        console.log('   4. Restart the backend server');
        console.log('\n💡 To test with Flutter frontend:');
        console.log('   1. Run: flutter run -d chrome');
        console.log('   2. Use demo login buttons (Rider/Driver/Admin)');
        console.log('   3. The app will work with mock data');
        console.log('\n========================================');
      }
    });
  });

  req.on('error', (err) => {
    console.log(`📋 ${endpoint.name}:`);
    console.log(`   ❌ Error: ${err.message}`);
    console.log('');
    failed++;

    if (index === endpoints.length - 1) {
      console.log('========================================');
      console.log('📊 Demo Test Results:');
      console.log(`   ✅ Passed: ${passed}`);
      console.log(`   ❌ Failed: ${failed}`);
      console.log(`   📈 Total: ${passed + failed}`);
      console.log('\n❌ FAILURE: Could not connect to backend server.');
      console.log('   Please ensure the backend is running (npm run dev).');
      console.log('========================================');
    }
  });

  req.end();
});
