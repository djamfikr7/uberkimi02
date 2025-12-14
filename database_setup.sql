-- Uber Clone Database Setup - PostgreSQL
-- Based on PRD requirements

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    profile_picture_url TEXT,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('rider', 'driver', 'admin')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMPTZ
);

-- Drivers Table
CREATE TABLE drivers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_type VARCHAR(20) NOT NULL CHECK (vehicle_type IN ('uber-x', 'uber-xl', 'comfort', 'black', 'pool')),
    vehicle_make VARCHAR(50) NOT NULL,
    vehicle_model VARCHAR(50) NOT NULL,
    vehicle_year INTEGER NOT NULL,
    vehicle_color VARCHAR(30) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    driver_rating DECIMAL(3,2) DEFAULT 5.0,
    total_rides INTEGER DEFAULT 0,
    is_online BOOLEAN DEFAULT false,
    current_location GEOMETRY(Point, 4326),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Rides Table
CREATE TABLE rides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rider_id UUID REFERENCES users(id) ON DELETE CASCADE,
    driver_id UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('requested', 'accepted', 'in_progress', 'completed', 'cancelled')),
    pickup_location GEOMETRY(Point, 4326) NOT NULL,
    dropoff_location GEOMETRY(Point, 4326) NOT NULL,
    pickup_address TEXT NOT NULL,
    dropoff_address TEXT NOT NULL,
    distance_km DECIMAL(10,2),
    duration_minutes INTEGER,
    base_fare DECIMAL(10,2) NOT NULL,
    final_fare DECIMAL(10,2),
    vehicle_type VARCHAR(20) NOT NULL CHECK (vehicle_type IN ('uber-x', 'uber-xl', 'comfort', 'black', 'pool')),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card', 'cash', 'wallet', 'paypal')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    ride_rating_rider DECIMAL(3,2),
    ride_rating_driver DECIMAL(3,2),
    rider_feedback TEXT,
    driver_feedback TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ
);

-- Ride Waypoints (for route tracking)
CREATE TABLE ride_waypoints (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    location GEOMETRY(Point, 4326) NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    speed_kmh DECIMAL(10,2),
    bearing DECIMAL(10,2)
);

-- Safety Events (from PRD)
CREATE TABLE safety_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID REFERENCES rides(id),
    event_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    location GEOMETRY(Point, 4326),
    audio_recording_url TEXT,
    photos TEXT[],
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'resolved', 'investigating')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

-- Emergency Contacts (from PRD)
CREATE TABLE emergency_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    relationship VARCHAR(50),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Ride Pooling (from PRD)
CREATE TABLE pool_rides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    master_ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'forming' CHECK (status IN ('forming', 'active', 'completed', 'cancelled')),
    max_riders INTEGER DEFAULT 4,
    current_riders INTEGER DEFAULT 1,
    route_polyline TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

CREATE TABLE pool_ride_riders (
    pool_id UUID REFERENCES pool_rides(id) ON DELETE CASCADE,
    rider_id UUID REFERENCES users(id) ON DELETE CASCADE,
    pickup_index INTEGER NOT NULL,
    dropoff_index INTEGER NOT NULL,
    fare_share DECIMAL(10,2) NOT NULL,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (pool_id, rider_id)
);

-- Loyalty Program (from PRD)
CREATE TABLE loyalty_tiers (
    tier_name VARCHAR(50) PRIMARY KEY,
    points_threshold INTEGER NOT NULL,
    benefits JSONB NOT NULL,
    multiplier DECIMAL(3,2) DEFAULT 1.0
);

CREATE TABLE user_points (
    user_id UUID REFERENCES users(id) PRIMARY KEY,
    total_points INTEGER DEFAULT 0,
    tier_points INTEGER DEFAULT 0,
    current_tier VARCHAR(50) REFERENCES loyalty_tiers(tier_name),
    points_expiring_next_month INTEGER DEFAULT 0,
    last_activity TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE point_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    points INTEGER NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    ride_id UUID REFERENCES rides(id) ON DELETE SET NULL,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Driver Incentives (from PRD)
CREATE TABLE driver_incentives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    driver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    incentive_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    criteria JSONB NOT NULL,
    achieved_at TIMESTAMPTZ,
    paid_out_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'expired'))
);

CREATE TABLE incentive_campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    budget DECIMAL(12,2),
    spent DECIMAL(12,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT true
);

-- Payments Table
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    transaction_id VARCHAR(100),
    payment_gateway_response JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

-- Fraud Detection (from PRD)
CREATE TABLE fraud_patterns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pattern_name VARCHAR(100) NOT NULL,
    ml_model_path TEXT,
    confidence_threshold DECIMAL(5,4),
    is_active BOOLEAN DEFAULT true,
    retrain_frequency INTERVAL DEFAULT '7 days',
    last_trained_at TIMESTAMPTZ
);

CREATE TABLE fraud_features (
    entity_id UUID NOT NULL,
    entity_type VARCHAR(20) NOT NULL,
    feature_name VARCHAR(100) NOT NULL,
    feature_value JSONB NOT NULL,
    extracted_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (entity_id, entity_type, feature_name)
);

CREATE TABLE fraud_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_id UUID NOT NULL,
    entity_type VARCHAR(20) NOT NULL,
    pattern_id UUID REFERENCES fraud_patterns(id),
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    confidence_score DECIMAL(5,4),
    status VARCHAR(20) DEFAULT 'detected' CHECK (status IN ('detected', 'reviewed', 'resolved', 'false_positive')),
    detected_at TIMESTAMPTZ DEFAULT NOW(),
    reviewed_at TIMESTAMPTZ,
    resolved_at TIMESTAMPTZ,
    notes TEXT
);

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT false,
    related_entity_id UUID,
    related_entity_type VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    read_at TIMESTAMPTZ
);

-- Reviews and Ratings
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    reviewer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    reviewee_id UUID REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_type VARCHAR(20) NOT NULL CHECK (review_type IN ('rider_to_driver', 'driver_to_rider')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Support Tickets
CREATE TABLE support_tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    ride_id UUID REFERENCES rides(id) ON DELETE SET NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

-- Support Messages
CREATE TABLE support_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_id UUID REFERENCES support_tickets(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    sender_type VARCHAR(20) NOT NULL CHECK (sender_type IN ('user', 'admin')),
    message TEXT NOT NULL,
    attachments JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_rides_rider_id ON rides(rider_id);
CREATE INDEX idx_rides_driver_id ON rides(driver_id);
CREATE INDEX idx_rides_status ON rides(status);
CREATE INDEX idx_rides_created_at ON rides(created_at);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_drivers_license_number ON drivers(license_number);
CREATE INDEX idx_drivers_vehicle_type ON drivers(vehicle_type);
CREATE INDEX idx_pool_rides_status ON pool_rides(status);
CREATE INDEX idx_pool_ride_riders_pool_id ON pool_ride_riders(pool_id);
CREATE INDEX idx_pool_ride_riders_rider_id ON pool_ride_riders(rider_id);
CREATE INDEX idx_payments_ride_id ON payments(ride_id);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_safety_events_ride_id ON safety_events(ride_id);
CREATE INDEX idx_fraud_events_entity_id ON fraud_events(entity_id);

-- Insert initial loyalty tiers
INSERT INTO loyalty_tiers (tier_name, points_threshold, benefits, multiplier) VALUES
    ('blue', 0, '{"benefits": ["Priority Support"]}', 1.0),
    ('gold', 100, '{"benefits": ["Free Cancellations", "Priority Pickup"]}', 1.1),
    ('platinum', 500, '{"benefits": ["VIP Support", "Complimentary Upgrades", "Flexible Cancellations"]}', 1.2),
    ('diamond', 1000, '{"benefits": ["All Benefits", "Dedicated Concierge", "Monthly Credits"]}', 1.3);

-- Insert initial fraud patterns
INSERT INTO fraud_patterns (pattern_name, ml_model_path, confidence_threshold, is_active) VALUES
    ('unusual_hours', NULL, 0.85, true),
    ('gps_spoofing', NULL, 0.90, true),
    ('device_change_velocity', NULL, 0.95, true),
    ('card_testing', NULL, 0.80, true);

-- Create spatial index for location-based queries
CREATE INDEX idx_rides_pickup_location ON rides USING GIST(pickup_location);
CREATE INDEX idx_rides_dropoff_location ON rides USING GIST(dropoff_location);
CREATE INDEX idx_drivers_current_location ON drivers USING GIST(current_location);
CREATE INDEX idx_ride_waypoints_location ON ride_waypoints USING GIST(location);

-- Create functions for common operations
CREATE OR REPLACE FUNCTION update_user_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_user_timestamp();

CREATE TRIGGER update_driver_updated_at
BEFORE UPDATE ON drivers
FOR EACH ROW
EXECUTE FUNCTION update_user_timestamp();

-- Create function to calculate ride distance
CREATE OR REPLACE FUNCTION calculate_ride_distance(ride_id UUID)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    distance DECIMAL(10,2);
BEGIN
    SELECT ST_Distance(
        (SELECT pickup_location FROM rides WHERE id = ride_id),
        (SELECT dropoff_location FROM rides WHERE id = ride_id)
    ) / 1000 INTO distance;
    
    UPDATE rides SET distance_km = distance WHERE id = ride_id;
    RETURN distance;
END;
$$ LANGUAGE plpgsql;

-- Create function to calculate ride fare
CREATE OR REPLACE FUNCTION calculate_ride_fare(ride_id UUID)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    base_fare DECIMAL(10,2);
    distance DECIMAL(10,2);
    vehicle_type VARCHAR(20);
    calculated_fare DECIMAL(10,2);
BEGIN
    SELECT base_fare, distance_km, vehicle_type INTO base_fare, distance, vehicle_type 
    FROM rides WHERE id = ride_id;
    
    -- Base fare calculation based on vehicle type
    IF vehicle_type = 'uber-x' THEN
        calculated_fare := base_fare + (distance * 1.2);
    ELSIF vehicle_type = 'uber-xl' THEN
        calculated_fare := base_fare + (distance * 1.8);
    ELSIF vehicle_type = 'comfort' THEN
        calculated_fare := base_fare + (distance * 2.5);
    ELSIF vehicle_type = 'black' THEN
        calculated_fare := base_fare + (distance * 3.5);
    ELSIF vehicle_type = 'pool' THEN
        calculated_fare := base_fare + (distance * 0.8);
    ELSE
        calculated_fare := base_fare + (distance * 1.2);
    END IF;
    
    UPDATE rides SET final_fare = calculated_fare WHERE id = ride_id;
    RETURN calculated_fare;
END;
$$ LANGUAGE plpgsql;