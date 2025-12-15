const { FraudDetectionService } = require('../../lib/fraudDetection');

describe('Fraud Detection Service', () => {
  beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
  });

  test('should detect suspicious ride requests', async () => {
    // Mock Ride model count method to return a high number
    const mockRideCount = jest.fn().mockResolvedValue(20);
    
    // Mock the Ride model
    jest.mock('../../lib/dbModels', () => ({
      Ride: {
        count: mockRideCount
      }
    }));

    const result = await FraudDetectionService.checkSuspiciousRideRequests('user123');
    
    expect(result.isSuspicious).toBe(true);
    expect(result.reason).toContain('User requested 20 rides in the last hour');
    expect(result.severity).toBe('high');
    expect(mockRideCount).toHaveBeenCalled();
  });

  test('should not flag normal ride requests', async () => {
    // Mock Ride model count method to return a normal number
    const mockRideCount = jest.fn().mockResolvedValue(2);
    
    // Mock the Ride model
    jest.mock('../../lib/dbModels', () => ({
      Ride: {
        count: mockRideCount
      }
    }));

    const result = await FraudDetectionService.checkSuspiciousRideRequests('user123');
    
    expect(result.isSuspicious).toBe(false);
    expect(mockRideCount).toHaveBeenCalled();
  });

  test('should handle database errors gracefully', async () => {
    // Mock Ride model count method to throw an error
    const mockRideCount = jest.fn().mockRejectedValue(new Error('Database error'));
    
    // Mock the Ride model
    jest.mock('../../lib/dbModels', () => ({
      Ride: {
        count: mockRideCount
      }
    }));

    const result = await FraudDetectionService.checkSuspiciousRideRequests('user123');
    
    expect(result.isSuspicious).toBe(false);
    expect(mockRideCount).toHaveBeenCalled();
  });

  test('should detect GPS spoofing attempts', async () => {
    const mockRideFindAll = jest.fn().mockResolvedValue([
      { pickupLocation: { lat: 36.752887, lng: 3.042048 }, requestedAt: new Date() },
      { pickupLocation: { lat: 36.752887, lng: 3.042048 }, requestedAt: new Date(Date.now() - 60000) },
      { pickupLocation: { lat: 36.752887, lng: 3.042048 }, requestedAt: new Date(Date.now() - 120000) }
    ]);
    
    // Mock the Ride model
    jest.mock('../../lib/dbModels', () => ({
      Ride: {
        findAll: mockRideFindAll
      }
    }));

    const result = await FraudDetectionService.checkGPSSpoofing('user123');
    
    expect(result.isSuspicious).toBe(true);
    expect(result.reason).toContain('Multiple rides from the same location');
    expect(result.severity).toBe('medium');
    expect(mockRideFindAll).toHaveBeenCalled();
  });

  test('should detect cancellation pattern fraud', async () => {
    const mockRideFindAll = jest.fn().mockResolvedValue([
      { status: 'cancelled', requestedAt: new Date() },
      { status: 'cancelled', requestedAt: new Date(Date.now() - 60000) },
      { status: 'cancelled', requestedAt: new Date(Date.now() - 120000) },
      { status: 'cancelled', requestedAt: new Date(Date.now() - 180000) },
      { status: 'cancelled', requestedAt: new Date(Date.now() - 240000) }
    ]);
    
    // Mock the Ride model
    jest.mock('../../lib/dbModels', () => ({
      Ride: {
        findAll: mockRideFindAll
      }
    }));

    const result = await FraudDetectionService.checkCancellationPatterns('user123');
    
    expect(result.isSuspicious).toBe(true);
    expect(result.reason).toContain('excessive cancellations');
    expect(result.severity).toBe('medium');
    expect(mockRideFindAll).toHaveBeenCalled();
  });
});