CREATE SCHEMA gamification;

CREATE TABLE gamification.seasons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE gamification.clans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    tier VARCHAR(20) NOT NULL DEFAULT 'bronze',
    total_score DECIMAL(10,2) NOT NULL DEFAULT 0,
    leader_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE gamification.clan_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clan_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'member',
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(clan_id, user_id)
);

CREATE TABLE gamification.achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    milestone INTEGER NOT NULL,
    achievement_type VARCHAR(50) DEFAULT 'reading_count',
    icon_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE gamification.user_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    achievement_id UUID NOT NULL,
    unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_visible BOOLEAN NOT NULL DEFAULT false,
    UNIQUE(user_id, achievement_id)
);

CREATE TABLE gamification.daily_missions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_type VARCHAR(50) NOT NULL,
    target_count INTEGER NOT NULL,
    xp_reward INTEGER NOT NULL DEFAULT 10,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE gamification.user_missions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    mission_id UUID NOT NULL,
    progress INTEGER NOT NULL DEFAULT 0,
    claimed BOOLEAN NOT NULL DEFAULT false,
    date DATE NOT NULL,
    UNIQUE(user_id, mission_id, date)
);

CREATE TABLE gamification.buffs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clan_id UUID NOT NULL,
    buff_type VARCHAR(50) NOT NULL,
    multiplier DECIMAL(3,2) NOT NULL,
    activated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE gamification.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    is_read BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_clan_members_user ON gamification.clan_members(user_id);
CREATE INDEX idx_clan_members_clan ON gamification.clan_members(clan_id);
CREATE INDEX idx_user_achievements_user ON gamification.user_achievements(user_id);
CREATE INDEX idx_user_missions_user ON gamification.user_missions(user_id);
CREATE INDEX idx_buffs_clan ON gamification.buffs(clan_id);
CREATE INDEX idx_notifications_user ON gamification.notifications(user_id);
CREATE INDEX idx_seasons_active ON gamification.seasons(is_active);