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

// Mock Users (since we don't have a users endpoint)
async function createMockUsers() {
    // This would normally be handled by your Rails API
    // For demo purposes, we'll store users in localStorage
    const users = JSON.parse(localStorage.getItem('users') || '[]');

    if (users.length === 0) {
        const mockUsers = [
            { id: 1, name: 'Alice Johnson' },
            { id: 2, name: 'Bob Smith' },
            { id: 3, name: 'Charlie Brown' },
            { id: 4, name: 'Diana Prince' }
        ];
        localStorage.setItem('users', JSON.stringify(mockUsers));
        return mockUsers;
    }

    return users;
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
    const users = await createMockUsers();

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
}

// Event Listeners
document.addEventListener('DOMContentLoaded', async function () {
    // Initialize tabs
    initializeTabs();

    // Load users
    await loadUsers();
});