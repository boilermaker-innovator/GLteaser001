// content.js
const GL_ATTR = 'data-gl-preview';

function createPreviewCard(data) {
    const card = document.createElement('div');
    card.className = 'gl-preview-card';
    
    // Create header
    const header = document.createElement('div');
    header.className = 'gl-header';
    header.innerHTML = `<h3>${data.title}</h3>`;
    card.appendChild(header);
    
    // Create tabs
    if (data.tabs) {
        const tabsContainer = document.createElement('div');
        tabsContainer.className = 'gl-tabs';
        data.tabs.forEach((tab, index) => {
            const button = document.createElement('button');
            button.className = `gl-tab ${index === 0 ? 'active' : ''}`;
            button.textContent = tab;
            button.onclick = () => switchTab(button, card);
            tabsContainer.appendChild(button);
        });
        card.appendChild(tabsContainer);
    }
    
    // Create content
    const content = document.createElement('div');
    content.className = 'gl-content';
    content.innerHTML = `<p>${data.description}</p>`;
    card.appendChild(content);
    
    return card;
}

function switchTab(clickedTab, card) {
    // Remove active class from all tabs
    card.querySelectorAll('.gl-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    // Add active class to clicked tab
    clickedTab.classList.add('active');
}

function attachPreviewToLink(link) {
    const previewData = JSON.parse(link.getAttribute(GL_ATTR));
    let card = null;
    
    link.addEventListener('mouseenter', (e) => {
        card = createPreviewCard(previewData);
        const rect = link.getBoundingClientRect();
        card.style.top = `${rect.bottom + window.scrollY + 5}px`;
        card.style.left = `${rect.left}px`;
        document.body.appendChild(card);
    });
    
    link.addEventListener('mouseleave', (e) => {
        if (card && !card.matches(':hover')) {
            card.remove();
        }
    });
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const glLinks = document.querySelectorAll(`[${GL_ATTR}]`);
    glLinks.forEach(attachPreviewToLink);
    
    // Log for debugging
    console.log(`GL Teaser initialized with ${glLinks.length} preview links`);
});
