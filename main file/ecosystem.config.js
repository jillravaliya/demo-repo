module.exports = {
    apps: [
        {
            name: 'daily-activity-tracker-yatricloud',
            script: './start.sh',
            cwd: '/home/ubuntu/daily-activity-tracker-yatricloud',
            instances: 1,
            autorestart: true,
            watch: false,
            max_memory_restart: '1G',
            env: {
                NODE_ENV: 'production',
                PORT: 3000
            },
            error_file: '/home/ubuntu/daily-activity-tracker-yatricloud/logs/err.log',
            out_file: '/home/ubuntu/daily-activity-tracker-yatricloud/logs/out.log',
            log_file: '/home/ubuntu/daily-activity-tracker-yatricloud/logs/combined.log',
            time: true
        }
    ]
};