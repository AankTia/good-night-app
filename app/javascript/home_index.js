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

function formatDateTime(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString();
}

function formatDuration(seconds) {
    if (!seconds) return 'N/A';

    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);

    if (hours > 0) {
        return `${hours}h ${minutes}m`;
    } else {
        return `${minutes}m`;
    }
}


function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 ${type === 'error' ? 'bg-red-500' :
        type === 'success' ? 'bg-green-500' :
            'bg-blue-500'
        } text-white`;
    notification.textContent = message;
    document.body.appendChild(notification);

    // Remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
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
    await updateSleepStatus();
    await loadSleepRecords();
    showLoading(false);
}

// Sleep Records Functions
async function toggleSleep() {
    if (!AppState.currentUser) return;

    showLoading(true);

    try {
        const response = await API.request(`/users/${AppState.currentUser.id}/sleep_records`, {
            method: 'POST'
        });

        showNotification(response.message, 'success');
        await updateSleepStatus();
        await loadSleepRecords();

    } catch (error) {
        console.error('Error toggling sleep:', error);
    } finally {
        showLoading(false);
    }
}

async function updateSleepStatus() {
    if (!AppState.currentUser) return;

    try {
        const response = await API.request(`/users/${AppState.currentUser.id}/sleep_records`);
        const records = response.sleep_records || [];

        // Find active record (no wake_up_time)
        const activeRecord = records.find(record => !record.wake_up_time);

        const statusIcon = document.getElementById('sleepIcon');
        const statusText = document.getElementById('sleepStatusText');
        const statusSubtext = document.getElementById('sleepSubtext');
        const toggleBtn = document.getElementById('sleepToggleBtn');
        const toggleText = document.getElementById('sleepToggleText');
        const currentSleepInfo = document.getElementById('currentSleepInfo');

        if (activeRecord) {
            // User is currently sleeping
            AppState.isActive = true;
            AppState.currentSleepRecord = activeRecord;

            statusIcon.className = 'fas fa-bed text-6xl text-green-400 mb-4';
            statusText.textContent = 'Sleeping...';
            statusSubtext.textContent = `Started at ${formatDateTime(activeRecord.sleep_time)}`;

            toggleBtn.className = 'bg-gradient-to-r from-dawn-orange to-orange-600 hover:from-orange-600 hover:to-orange-700 text-white font-bold py-4 px-8 rounded-full text-xl transition-all transform hover:scale-105 shadow-lg';
            toggleText.innerHTML = '<i class="fas fa-stop mr-2"></i>Wake Up';

            const sleepTime = new Date(activeRecord.sleep_time);
            const duration = Math.floor((Date.now() - sleepTime.getTime()) / 1000);

            currentSleepInfo.innerHTML = `
                        <div class="space-y-2">
                            <p><span class="text-gray-400">Started:</span> ${formatDateTime(activeRecord.sleep_time)}</p>
                            <p><span class="text-gray-400">Duration:</span> ${formatDuration(duration)}</p>
                        </div>
                    `;
        } else {
            // User is not sleeping
            AppState.isActive = false;
            AppState.currentSleepRecord = null;

            statusIcon.className = 'fas fa-moon text-6xl text-sleep-purple mb-4';
            statusText.textContent = 'Ready to Sleep';
            statusSubtext.textContent = 'Click the button below to start tracking';

            toggleBtn.className = 'bg-gradient-to-r from-sleep-purple to-purple-600 hover:from-purple-600 hover:to-purple-700 text-white font-bold py-4 px-8 rounded-full text-xl transition-all transform hover:scale-105 shadow-lg';
            toggleText.innerHTML = '<i class="fas fa-play mr-2"></i>Clock In';

            currentSleepInfo.innerHTML = '<p class="text-gray-300">No active sleep session</p>';
        }

    } catch (error) {
        console.error('Error updating sleep status:', error);
    }
}

async function loadSleepRecords() {
    if (!AppState.currentUser) return;

    try {
        const response = await API.request(`/users/${AppState.currentUser.id}/sleep_records`);
        const records = response.sleep_records || [];

        const recordsList = document.getElementById('sleepRecordsList');

        if (records.length === 0) {
            recordsList.innerHTML = '<p class="text-gray-300 text-center py-8">No sleep records yet</p>';
            return;
        }

        recordsList.innerHTML = records.map(record => `
                    <div class="bg-white/5 rounded-lg p-4 mb-4 border border-white/10">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <i class="fas ${record.wake_up_time ? 'fa-bed' : 'fa-moon'} text-2xl ${record.wake_up_time ? 'text-green-400' : 'text-yellow-400'}"></i>
                                <div>
                                    <p class="font-semibold">
                                        ${record.wake_up_time ? 'Completed Sleep' : 'Currently Sleeping'}
                                    </p>
                                    <p class="text-sm text-gray-400">
                                        Started: ${formatDateTime(record.sleep_time)}
                                    </p>
                                    ${record.wake_up_time ? `
                                        <p class="text-sm text-gray-400">
                                            Ended: ${formatDateTime(record.wake_up_time)}
                                        </p>
                                    ` : ''}
                                </div>
                            </div>
                            <div class="text-right">
                                <p class="text-2xl font-bold ${record.duration_seconds ? 'text-green-400' : 'text-yellow-400'}">
                                    ${record.duration_seconds ? formatDuration(record.duration_seconds) : 'Active'}
                                </p>
                            </div>
                        </div>
                    </div>
                `).join('');

    } catch (error) {
        console.error('Error loading sleep records:', error);
    }
}

// Friends Functions
async function loadFollowings() {
    if (!AppState.currentUser) return;

    try {
        const response = await API.request(`/users/${AppState.currentUser.id}/followings`);
        const followings = response.followings || [];

        const friendsList = document.getElementById('friendsList');

        if (followings.length === 0) {
            friendsList.innerHTML = '<p class="text-gray-300 text-center">Not following anyone yet</p>';
            return;
        }

        friendsList.innerHTML = followings.map(friend => `
                    <div class="flex items-center justify-between py-2 px-3 bg-white/5 rounded-lg mb-2">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-user text-blue-400"></i>
                            <span>${friend.name}</span>
                        </div>
                        <button onclick="unfollowUser(${friend.id})" class="text-red-400 hover:text-red-300 transition-colors">
                            <i class="fas fa-user-minus"></i>
                        </button>
                    </div>
                `).join('');

    } catch (error) {
        console.error('Error loading followings:', error);
    }
}
async function followUser() {
    const targetUserId = document.getElementById('availableUsersSelect').value;
    if (!targetUserId || !AppState.currentUser) return;

    showLoading(true);

    try {
        await API.request(`/users/${AppState.currentUser.id}/followings`, {
            method: 'POST',
            body: JSON.stringify({ target_user_id: targetUserId })
        });

        showNotification('Successfully followed user!', 'success');
        document.getElementById('availableUsersSelect').value = '';
        await loadFollowings();
        await loadLeaderboard();

    } catch (error) {
        console.error('Error following user:', error);
    } finally {
        showLoading(false);
    }
}

async function unfollowUser(userId) {
    if (!AppState.currentUser) return;

    showLoading(true);

    try {
        await API.request(`/users/${AppState.currentUser.id}/followings/${userId}`, {
            method: 'DELETE'
        });

        showNotification('Successfully unfollowed user!', 'success');
        await loadFollowings();
        await loadLeaderboard();

    } catch (error) {
        console.error('Error unfollowing user:', error);
    } finally {
        showLoading(false);
    }
}

// Leaderboard Functions
async function loadLeaderboard() {
    if (!AppState.currentUser) return;

    try {
        const response = await API.request(`/users/${AppState.currentUser.id}/sleep_records/friends_sleep_records`);
        const records = response.sleep_records || [];

        const leaderboardList = document.getElementById('leaderboardList');

        if (records.length === 0) {
            leaderboardList.innerHTML = '<p class="text-gray-300 text-center py-8">No friends data available</p>';
            return;
        }

        leaderboardList.innerHTML = records.map((record, index) => `
                    <div class="flex items-center justify-between py-4 px-4 bg-white/5 rounded-lg mb-3 border-l-4 ${index === 0 ? 'border-yellow-400' :
                index === 1 ? 'border-gray-300' :
                    index === 2 ? 'border-orange-400' :
                        'border-purple-400'
            }">
                        <div class="flex items-center space-x-4">
                            <div class="w-8 h-8 rounded-full flex items-center justify-center ${index === 0 ? 'bg-yellow-400 text-black' :
                index === 1 ? 'bg-gray-300 text-black' :
                    index === 2 ? 'bg-orange-400 text-black' :
                        'bg-purple-400'
            } font-bold">
                                ${index + 1}
                            </div>
                            <div>
                                <p class="font-semibold">${record.user.name}</p>
                                <p class="text-sm text-gray-400">
                                    ${formatDateTime(record.sleep_time)} - ${formatDateTime(record.wake_up_time)}
                                </p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="text-xl font-bold text-green-400">
                                ${formatDuration(record.duration_seconds)}
                            </p>
                        </div>
                    </div>
                `).join('');

    } catch (error) {
        console.error('Error loading leaderboard:', error);
    }
}

// Modal Management
function showCreateUserModal() {
    const modal = document.getElementById('createUserModal');
    modal.classList.remove('hidden');
    modal.classList.add('flex');
}

function hideCreateUserModal() {
    const modal = document.getElementById('createUserModal');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
    document.getElementById('newUserName').value = '';
}

async function handleCreateUser() {
    const name = document.getElementById('newUserName').value.trim();
    if (!name) {
        showNotification('Please enter a name', 'error');
        return;
    }

    showLoading(true);

    try {
        const newUser = await createUser(name);
        await loadUsers();
        hideCreateUserModal();
        showNotification('Profile created successfully!', 'success');

        // Auto-select the new user
        document.getElementById('mainUserSelect').value = newUser.id;

    } catch (error) {
        console.error('Error creating user:', error);
    } finally {
        showLoading(false);
    }
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

    // Sleep toggle button
    document.getElementById('sleepToggleBtn').addEventListener('click', toggleSleep);

    // Follow user button
    document.getElementById('followUserBtn').addEventListener('click', followUser);

    // Create user buttons
    document.getElementById('createUserBtn').addEventListener('click', showCreateUserModal);
    document.getElementById('newUserBtn').addEventListener('click', showCreateUserModal);
    document.getElementById('cancelCreateUser').addEventListener('click', hideCreateUserModal);
    document.getElementById('confirmCreateUser').addEventListener('click', handleCreateUser);

    // Enter key support for user creation
    document.getElementById('newUserName').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            handleCreateUser();
        }
    });

    // Update sleep status periodically for active sessions
    setInterval(() => {
        if (AppState.isActive) {
            updateSleepStatus();
        }
    }, 30000); // Update every 30 seconds
});

// Make unfollowUser available globally
window.unfollowUser = unfollowUser;