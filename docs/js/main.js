// Mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuButton = document.querySelector('.mobile-menu-button');
    const mobileMenu = document.querySelector('.mobile-menu');
    
    if (mobileMenuButton && mobileMenu) {
        mobileMenuButton.addEventListener('click', function() {
            mobileMenu.classList.toggle('hidden');
        });
    }
    
    // Smooth scrolling for navigation links
    const navLinks = document.querySelectorAll('.nav-link, .nav-link-mobile');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href && href.startsWith('#')) {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                    
                    // Close mobile menu if open
                    if (!mobileMenu.classList.contains('hidden')) {
                        mobileMenu.classList.add('hidden');
                    }
                    
                    // Update active nav link
                    updateActiveNavLink(href);
                }
            }
        });
    });
    
    // Update active navigation link based on scroll position
    function updateActiveNavLink(activeHref = null) {
        const sections = ['#home', '#features', '#getting-started', '#commands'];
        const navLinks = document.querySelectorAll('.nav-link, .nav-link-mobile');
        
        if (activeHref) {
            // Manually set active link
            navLinks.forEach(link => {
                link.classList.remove('text-plumer-600');
                link.classList.add('text-gray-600');
                
                if (link.getAttribute('href') === activeHref) {
                    link.classList.remove('text-gray-600');
                    link.classList.add('text-plumer-600');
                }
            });
        } else {
            // Auto-detect based on scroll position
            let currentSection = '#home';
            
            sections.forEach(section => {
                const element = document.querySelector(section);
                if (element) {
                    const rect = element.getBoundingClientRect();
                    if (rect.top <= 100 && rect.bottom >= 100) {
                        currentSection = section;
                    }
                }
            });
            
            navLinks.forEach(link => {
                link.classList.remove('text-plumer-600');
                link.classList.add('text-gray-600', 'hover:text-plumer-600');
                
                if (link.getAttribute('href') === currentSection) {
                    link.classList.remove('text-gray-600');
                    link.classList.add('text-plumer-600');
                }
            });
        }
    }
    
    // Scroll spy for navigation
    window.addEventListener('scroll', function() {
        updateActiveNavLink();
    });
    
    // Copy code to clipboard functionality
    function addCopyButtons() {
        const codeBlocks = document.querySelectorAll('.code-block');
        
        codeBlocks.forEach((block, index) => {
            // Create copy button
            const copyButton = document.createElement('button');
            copyButton.className = 'absolute top-2 right-2 bg-gray-700 hover:bg-gray-600 text-white text-xs px-2 py-1 rounded transition-colors';
            copyButton.textContent = 'Copy';
            copyButton.setAttribute('data-copy-index', index);
            
            // Make code block relative positioned
            block.style.position = 'relative';
            block.appendChild(copyButton);
            
            // Add click event
            copyButton.addEventListener('click', function() {
                const codeContent = block.querySelector('code').textContent;
                
                // Create temporary textarea to copy text
                const textarea = document.createElement('textarea');
                textarea.value = codeContent.replace(/<br>/g, '\n').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand('copy');
                document.body.removeChild(textarea);
                
                // Update button text
                const originalText = copyButton.textContent;
                copyButton.textContent = 'Copied!';
                copyButton.classList.add('bg-green-600');
                
                setTimeout(() => {
                    copyButton.textContent = originalText;
                    copyButton.classList.remove('bg-green-600');
                }, 2000);
            });
        });
    }
    
    // Add copy buttons to code blocks
    addCopyButtons();
    
    // Animate elements on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-fade-in-up');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    // Observe elements for animation
    const elementsToAnimate = document.querySelectorAll('.relative:not(.gradient-bg .relative)');
    elementsToAnimate.forEach(el => {
        observer.observe(el);
    });
    
    // Add search functionality (future enhancement)
    function initializeSearch() {
        const searchInput = document.querySelector('#search-input');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                const query = this.value.toLowerCase();
                // Implement search logic here
                console.log('Searching for:', query);
            });
        }
    }
    
    // Theme toggle (if implemented)
    function initializeThemeToggle() {
        const themeToggle = document.querySelector('#theme-toggle');
        if (themeToggle) {
            themeToggle.addEventListener('click', function() {
                document.documentElement.classList.toggle('dark');
                localStorage.setItem('theme', document.documentElement.classList.contains('dark') ? 'dark' : 'light');
            });
            
            // Check for saved theme preference or default to light
            const savedTheme = localStorage.getItem('theme');
            if (savedTheme === 'dark') {
                document.documentElement.classList.add('dark');
            }
        }
    }
    
    // Initialize additional features
    initializeSearch();
    initializeThemeToggle();
    
    // Add some nice hover effects
    const cards = document.querySelectorAll('.relative:not(.gradient-bg .relative)');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.classList.add('transform', 'scale-105', 'transition-transform', 'duration-200');
        });
        
        card.addEventListener('mouseleave', function() {
            this.classList.remove('transform', 'scale-105');
        });
    });
    
    // Console welcome message
    console.log('%cWelcome to Plumer CLI Documentation! 🪶', 'color: #6366f1; font-size: 16px; font-weight: bold;');
    console.log('%cCheck out the source code at: https://github.com/dennokorir/plumer', 'color: #4f46e5;');
});