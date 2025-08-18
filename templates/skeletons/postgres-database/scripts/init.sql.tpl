-- Initial schema for $${parameters.name} database
-- PostgreSQL version

-- Create extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create trips table for travel excursions
CREATE TABLE trips (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    duration INTEGER NOT NULL CHECK (duration > 0), -- in hours
    max_guests INTEGER NOT NULL CHECK (max_guests > 0),
    available BOOLEAN DEFAULT TRUE,
    tags TEXT[], -- PostgreSQL array type
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on location for faster searches
CREATE INDEX idx_trips_location ON trips(location);
CREATE INDEX idx_trips_available ON trips(available);
CREATE INDEX idx_trips_price ON trips(price);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_trips_updated_at 
    BEFORE UPDATE ON trips 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO trips (name, description, location, price, duration, max_guests, tags) VALUES
('Island Hiking Adventure', 'Explore the beautiful mountain trails', 'Tenerife', 45.00, 6, 12, ARRAY['hiking', 'nature', 'adventure']),
('Beach Relaxation Tour', 'Enjoy pristine beaches and crystal waters', 'Gran Canaria', 35.00, 4, 20, ARRAY['beach', 'relaxation', 'swimming']),
('Volcanic Landscape Tour', 'Discover unique volcanic formations', 'Lanzarote', 55.00, 8, 15, ARRAY['volcano', 'geology', 'adventure']);

-- Grant permissions (adjust as needed for your application user)
-- GRANT SELECT, INSERT, UPDATE, DELETE ON trips TO app_user;