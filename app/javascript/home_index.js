// Application State
const AppState = {
    currentUser: null,
    isActive: false,
    currentSleepRecord: null,
    apiBase: 'http://localhost:3000/api/v1' // Adjust this to your Rails API URL
};

// Utility Functions
const API = {
    async request(endpoint, options = {}) {
        const url = `${AppState.apiBase}${endpoint}`;
        const config = {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            ...options
        };

        try {
            const response = await fetch(url, config);
            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'API request failed');
            }

            return data;
        } catch (error) {
            console.error('API Error:', error);
            showNotification(error.message, 'error');
            throw error;
        }
    }
};

function showLoading(show = true) {
    const overlay = document.getElementById('loadingOverlay');
    overlay.classList.toggle('hidden', !show);
    overlay.classList.toggle('flex', show);
}

// Tab Management
function initializeTabs() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    const tabPanels = document.querySelectorAll('.tab-panel');

    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetTab = button.getAttribute('data-tab');

            // Remove active class from all buttons and panels
            tabButtons.forEach(btn => {
                btn.classList.remove('active', 'bg-white/10', 'text-white');
                btn.classList.add('text-gray-400', 'hover:text-white');
            });
            tabPanels.forEach(panel => {
                panel.classList.add('hidden');
                panel.classList.remove('active');
            });

            // Add active class to clicked button and corresponding panel
            button.classList.add('active', 'bg-white/10', 'text-white');
            button.classList.remove('text-gray-400', 'hover:text-white');

            const targetPanel = document.getElementById(`${targetTab}Tab`);
            targetPanel.classList.remove('hidden');
            targetPanel.classList.add('active');

            // Load content based on active tab
            if (targetTab === 'records') {
                loadSleepRecords();
            } else if (targetTab === 'friends') {
                loadFollowings();
            } else if (targetTab === 'leaderboard') {
                loadLeaderboard();
            }
        });
    });

    // Set initial active state
    const firstTab = tabButtons[0];
    firstTab.classList.add('active', 'bg-white/10', 'text-white');
    firstTab.classList.remove('text-gray-400');
}

async function createUser(name) {
    const users = JSON.parse(localStorage.getItem('users') || '[]');
    const newUser = {
        id: Math.max(...users.map(u => u.id), 0) + 1,
        name: name
    };
    users.push(newUser);
    localStorage.setItem('users', JSON.stringify(users));
    return newUser;
}

async function loadUsers() {
    try {
        const response = await API.request('/users');
        const users = response.users;

        // Populate user selects
        const selects = [
            document.getElementById('userSelect'),
            document.getElementById('mainUserSelect'),
            document.getElementById('availableUsersSelect')
        ];

        selects.forEach(select => {
            select.innerHTML = '<option value="">Select User</option>';
            users.forEach(user => {
                const option = document.createElement('option');
                option.value = user.id;
                option.textContent = user.name;
                select.appendChild(option);
            });
        });
    } catch (error) {
        console.error('Error fetch users:', error);
    }
}

// User Management
async function selectUser(userId) {
    const users = JSON.parse(localStorage.getItem('users') || '[]');
    const user = users.find(u => u.id == userId);

    if (!user) return;

    AppState.currentUser = user;

    // Switch screens
    document.getElementById('userSelectionScreen').classList.add('hidden');
    document.getElementById('mainAppScreen').classList.remove('hidden');

    // Load initial data
    showLoading(true);
    // await updateSleepStatus();
    // await loadSleepRecords();
    showLoading(false);
}

// Event Listeners
document.addEventListener('DOMContentLoaded', async function () {
    // Initialize tabs
    initializeTabs();

    // Load users
    await loadUsers();

    // User selection
    document.getElementById('mainUserSelect').addEventListener('change', function () {
        const userId = this.value;
        if (userId) {
            selectUser(userId);
        }
    });

    document.getElementById('userSelect').addEventListener('change', function () {
        const userId = this.value;
        if (userId) {
            selectUser(userId);
        }
    });
});