/**
 * Carmel Garden - Interactive Scripts & CMS Loader
 */

 
/* ─── BACK TO TOP BUTTON ────────────────────────────────── */
window.addEventListener('scroll', function () {
  const btn = document.getElementById('btt');
  if (window.scrollY > 400) {
    btn.style.display = 'flex';
  } else {
    btn.style.display = 'none';
  }
});
 
/* ─── COUNT-UP ANIMATION ────────────────────────────────── */
function runCountUp(el) {
    if (el.classList.contains('counted')) return;
    el.classList.add('counted'); // Prevent multiple runs

    const target = parseInt(el.getAttribute('data-target')) || 0;
    const duration = 2000; // 2 seconds animation
    const startTime = performance.now();
    
    // Check if there is an adjoining suffix span, or just leave it alone
    // It's perfectly fine to just update the number inside the <span>.
    function updateCounter(currentTime) {
        const elapsedTime = currentTime - startTime;
        const progress = Math.min(elapsedTime / duration, 1);
        
        // Easing function (easeOutExpo)
        const easeProgress = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
        const currentVal = Math.floor(easeProgress * target);
        
        el.textContent = currentVal;

        if (progress < 1) {
            requestAnimationFrame(updateCounter);
        } else {
            el.textContent = target; // Ensure exact final value
        }
    }
    
    requestAnimationFrame(updateCounter);
}

document.addEventListener('DOMContentLoaded', () => {
    /* Setup count-up intersection observer */
    const countElements = document.querySelectorAll('.count');
    if (countElements.length > 0) {
        const observer = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    runCountUp(entry.target);
                    obs.unobserve(entry.target); // Unobserve to prevent running again
                }
            });
        }, { threshold: 0.1 });
        
        countElements.forEach(el => observer.observe(el));
    }
});
 
/* ─── ENQUIRY FORM SUBMIT ────────────────────────────────── */
const sendBtn = document.getElementById('sendBtn');
if (sendBtn) {
  sendBtn.addEventListener('click', function () {
    alert('Thank you! We will get back to you shortly.');
  });
}
 
/* ─── HIGHLIGHT ACTIVE NAV LINK BY URL ─────────────────── */
const navLinks = document.querySelectorAll('.nav-links a');
const currentPath = window.location.pathname;
const currentPage = currentPath.split('/').pop() || 'index.html';

navLinks.forEach(function (link) {
  link.classList.remove('active');
  const linkPath = link.getAttribute('href').split('/').pop();
  if (linkPath === currentPage) {
    link.classList.add('active');
  }
});
 
/* ─── NAVBAR SHADOW ON SCROLL ────────────────────────────── */
window.addEventListener('scroll', function () {
  const navbar = document.querySelector('.navbar');
  if (navbar) {
    if (window.scrollY > 50) {
      navbar.style.boxShadow = '0 4px 24px rgba(0,0,0,0.15)';
    } else {
      navbar.style.boxShadow = '0 2px 16px rgba(0,0,0,0.1)';
    }
  }
});


document.addEventListener('DOMContentLoaded', () => {

    // --- 0. Fetch Dynamic Content from CMS Backend ---
    fetch('/api/content')
        .then(response => response.json())
        .then(data => {
            // Update Texts mapping
            Object.keys(data.texts).forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.innerHTML = data.texts[id];
                }
            });

            // Update Background Images mapping
            Object.keys(data.images).forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.style.backgroundImage = data.images[id];
                }
            });

            // Update Links mapping (e.g., brochure URL)
            if (data.links) {
                Object.keys(data.links).forEach(id => {
                    const element = document.getElementById(id);
                    if (element) {
                        element.href = data.links[id];
                    }
                });
            }
        })
        .catch(error => console.error("Could not load dynamic CMS content:", error));


    // --- 1. Sticky Navbar on Scroll ---
    const topBar = document.querySelector('.top-bar');
    const navbar = document.getElementById('navbar');
    
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
            if (topBar && window.innerWidth > 900) {
                navbar.style.top = '0';
            }
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // --- 2. Mobile Menu Toggle ---
    const mobileMenuBtn = document.getElementById('mobile-menu-btn');
    const navLinks = document.getElementById('nav-links');
    
    if (mobileMenuBtn && navLinks) {
        mobileMenuBtn.addEventListener('click', () => {
            const isActive = navLinks.classList.contains('active');
            if (isActive) {
                navLinks.classList.remove('active');
                mobileMenuBtn.innerHTML = '<i class="fa-solid fa-bars"></i>';
            } else {
                navLinks.classList.add('active');
                mobileMenuBtn.innerHTML = '<i class="fa-solid fa-times"></i>';
            }
        });
    }

    // --- 3. Mobile Dropdown Toggle ---
    const dropdowns = document.querySelectorAll('.dropdown');
    dropdowns.forEach(dropdown => {
        dropdown.addEventListener('click', (e) => {
            if (window.innerWidth <= 900) {
                const link = dropdown.querySelector('a');
                if (e.target === link || e.target.parentNode === link) {
                    e.preventDefault();
                    dropdown.classList.toggle('active');
                }
            }
        });
    });

    // --- 4. Intersection Observer for Fade-Up Animations ---
    const fadeElements = document.querySelectorAll('.fade-up-element');
    const fadeOptions = { root: null, threshold: 0.15, rootMargin: "0px 0px -50px 0px" };
    
    const fadeObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, fadeOptions);
    
    fadeElements.forEach(element => fadeObserver.observe(element));

    // --- 5. Smooth Scrolling for Anchor Links ---
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                e.preventDefault();
                targetElement.scrollIntoView({ behavior: 'smooth' });
                
                if (window.innerWidth <= 900 && navLinks && navLinks.classList.contains('active')) {
                    navLinks.classList.remove('active');
                    mobileMenuBtn.innerHTML = '<i class="fa-solid fa-bars"></i>';
                }
            }
        });
    });

    // --- 6. Live Chatbox Logic (WhatsApp Style) ---
    const chatbotHTML = `
    <div id="school-chatbot" class="chatbot-container collapsed">
        <div class="chatbot-header">
            <div class="chatbot-title">
                <i class="fa-solid fa-robot"></i> Carmel Assistant
            </div>
            <button id="chatbot-close-btn"><i class="fa-solid fa-times"></i></button>
        </div>
        <div class="chatbot-messages" id="chatbot-messages"></div>
        <div class="chatbot-quick-replies" id="chatbot-quick-replies">
            <button class="chat-qr-btn">Admissions</button>
            <button class="chat-qr-btn">Fees</button>
            <button class="chat-qr-btn">Timings</button>
            <button class="chat-qr-btn">Contact</button>
            <button class="chat-qr-btn">Facilities</button>
        </div>
        <div class="chatbot-input-area">
            <input type="text" id="chatbot-input" placeholder="Type a message..." autocomplete="off">
            <button id="chatbot-send-btn"><i class="fa-solid fa-paper-plane"></i></button>
        </div>
    </div>
    <button id="chatbot-toggle-btn" class="chatbot-toggle-btn">
        <i class="fa-solid fa-comment-dots"></i>
    </button>
    `;

    document.body.insertAdjacentHTML('beforeend', chatbotHTML);

    const botContainer = document.getElementById('school-chatbot');
    const botToggle = document.getElementById('chatbot-toggle-btn');
    const botClose = document.getElementById('chatbot-close-btn');
    const botMessages = document.getElementById('chatbot-messages');
    const botInput = document.getElementById('chatbot-input');
    const botSend = document.getElementById('chatbot-send-btn');
    const qrButtons = document.querySelectorAll('.chat-qr-btn');

    let isBotTyping = false;
    let hasWelcomed = false;

    const qaRules = [
        { keywords: ['admission', 'apply', 'join', 'enroll'], answer: "For admissions, please visit our 'Apply Now' page or contact the school office. Admissions are currently open for KG to Class XI." },
        { keywords: ['fee', 'payment', 'cost'], answer: "Fee structures vary by class. Please contact the administration office at +91 98765 43210 for precise details." },
        { keywords: ['time', 'timing', 'hour', 'open'], answer: "School timings: Morning (8:30 AM to 12:00 PM), Lunch (12:00 PM to 12:30 PM), Afternoon (12:30 PM to 3:20 PM)." },
        { keywords: ['contact', 'phone', 'call', 'email'], answer: "You can reach us at +91 98765 43210 or email info@carmelgarden.edu.in." },
        { keywords: ['location', 'address', 'where'], answer: "We are located at Coimbatore, Tamil Nadu. Find our exact location on the Contact mapping page." },
        { keywords: ['facility', 'facilities', 'lab', 'sports'], answer: "We offer Smart Classrooms, Computer Labs, Library, Sports complexes, and Montessori sections. Visit the 'Facilities' page for more!" },
        { keywords: ['hi', 'hello', 'hey'], answer: "Hello! Welcome to Carmel Garden. How can I help you today?" }
    ];

    function appendMessage(text, sender) {
        const msgDiv = document.createElement('div');
        msgDiv.className = `chat-msg ${sender}`;
        msgDiv.innerText = text;
        botMessages.appendChild(msgDiv);
        botMessages.scrollTop = botMessages.scrollHeight;
    }

    function showTyping() {
        const typingDiv = document.createElement('div');
        typingDiv.className = 'chat-msg bot chat-typing';
        typingDiv.id = 'chat-typing-indicator';
        typingDiv.innerText = 'typing...';
        botMessages.appendChild(typingDiv);
        botMessages.scrollTop = botMessages.scrollHeight;
    }

    function removeTyping() {
        const typingDiv = document.getElementById('chat-typing-indicator');
        if (typingDiv) typingDiv.remove();
    }

    function processUserMessage(text) {
        text = text.trim();
        if (isBotTyping || !text) return;

        appendMessage(text, 'user');
        botInput.value = '';
        isBotTyping = true;
        showTyping();

        setTimeout(() => {
            removeTyping();
            let foundAnswer = "I'm sorry, I didn't quite catch that. Try asking about Admissions, Fees, Timings, Contact info, or Facilities!";
            const lowerText = text.toLowerCase();
            
            for (let rule of qaRules) {
                if (rule.keywords.some(kw => lowerText.includes(kw))) {
                    foundAnswer = rule.answer;
                    break;
                }
            }
            appendMessage(foundAnswer, 'bot');
            isBotTyping = false;
        }, 1200);
    }

    botToggle.addEventListener('click', () => {
        botContainer.classList.remove('collapsed');
        botToggle.style.transform = 'scale(0)';
        if (!hasWelcomed) {
            hasWelcomed = true;
            appendMessage("Hello! 👋 Welcome to Carmel Garden. How can I help you regarding admissions, fees, timings, or facilities?", 'bot');
        }
    });

    botClose.addEventListener('click', () => {
        botContainer.classList.add('collapsed');
        botToggle.style.transform = 'scale(1)';
    });

    botSend.addEventListener('click', () => processUserMessage(botInput.value));
    botInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') processUserMessage(botInput.value);
    });

    qrButtons.forEach(btn => {
        btn.addEventListener('click', () => processUserMessage(btn.innerText));
    });

    // --- 7. Facilities Tabs Logic ---
    const tabBtns = document.querySelectorAll('.fac-tab-btn');
    const tabContents = document.querySelectorAll('.fac-tab-content');

    if (tabBtns.length > 0 && tabContents.length > 0) {
        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                // Remove active state from all buttons & contents
                tabBtns.forEach(b => b.classList.remove('active'));
                tabContents.forEach(c => c.classList.remove('active'));

                // Add active state to clicked button
                btn.classList.add('active');

                // Show target content dynamically
                const targetId = `tab-${btn.getAttribute('data-tab')}`;
                const targetContent = document.getElementById(targetId);
                
                if (targetContent) {
                    targetContent.classList.add('active');
                }
            });
        });
    }

    // --- 8. Footer Updates Marquee Smoothing ---
    const updateList = document.getElementById('footerUpdateList');
    if (updateList) {
        // Clone the nodes to create a seamless scrolling loop
        const clone = updateList.innerHTML;
        updateList.innerHTML += clone;
    }
    // --- 9. Daily Bible Verse ---
    const bibleVerses = [
        { text: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.", book: "John", ref: "3:16" },
        { text: "Trust in the Lord with all your heart and lean not on your own understanding.", book: "Proverbs", ref: "3:5" },
        { text: "I can do all this through him who gives me strength.", book: "Philippians", ref: "4:13" },
        { text: "And we know that in all things God works for the good of those who love him, who have been called according to his purpose.", book: "Romans", ref: "8:28" },
        { text: "The Lord is my shepherd, I lack nothing.", book: "Psalm", ref: "23:1" },
        { text: "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", book: "Joshua", ref: "1:9" },
        { text: "But the fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness,", book: "Galatians", ref: "5:22" },
        { text: "Therefore do not worry about tomorrow, for tomorrow will worry about itself. Each day has enough trouble of its own.", book: "Matthew", ref: "6:34" },
        { text: "Cast all your anxiety on him because he cares for you.", book: "1 Peter", ref: "5:7" },
        { text: "For I know the plans I have for you,” declares the Lord, “plans to prosper you and not to harm you, plans to give you hope and a future.", book: "Jeremiah", ref: "29:11" },
        { text: "In the beginning God created the heavens and the earth.", book: "Genesis", ref: "1:1" },
        { text: "Do not conform to the pattern of this world, but be transformed by the renewing of your mind.", book: "Romans", ref: "12:2" },
        { text: "But those who hope in the Lord will renew their strength. They will soar on wings like eagles.", book: "Isaiah", ref: "40:31" },
        { text: "Jesus Christ is the same yesterday and today and forever.", book: "Hebrews", ref: "13:8" },
        { text: "Come to me, all you who are weary and burdened, and I will give you rest.", book: "Matthew", ref: "11:28" },
        { text: "If God is for us, who can be against us?", book: "Romans", ref: "8:31" },
        { text: "Rejoice always, pray continually, give thanks in all circumstances.", book: "1 Thessalonians", ref: "5:16-18" },
        { text: "The Lord is my light and my salvation—whom shall I fear?", book: "Psalm", ref: "27:1" },
        { text: "Whatever you do, work at it with all your heart, as working for the Lord, not for human masters.", book: "Colossians", ref: "3:23" },
        { text: "Let all that you do be done in love.", book: "1 Corinthians", ref: "16:14" },
        { text: "He has shown you, O mortal, what is good. And what does the Lord require of you? To act justly and to love mercy and to walk humbly with your God.", book: "Micah", ref: "6:8" },
        { text: "Thy word is a lamp unto my feet, and a light unto my path.", book: "Psalm", ref: "119:105" },
        { text: "Draw near to God, and he will draw near to you.", book: "James", ref: "4:8" },
        { text: "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.", book: "1 Corinthians", ref: "13:4" },
        { text: "A joyful heart is good medicine, but a crushed spirit dries up the bones.", book: "Proverbs", ref: "17:22" }
    ];

    const dailyVerseWrapper = document.getElementById('dailyVerseWrapper');
    const nextVerseBtn = document.getElementById('nextVerseBtn');

    if (dailyVerseWrapper) {
        const verseTextEl = dailyVerseWrapper.querySelector('.verse-text');
        const refBookEl = dailyVerseWrapper.querySelector('.ref-book');
        const refChapEl = dailyVerseWrapper.querySelector('.ref-chapter');
        const innerWrapper = dailyVerseWrapper.querySelector('.verse-text-inner');
        
        let currentVerseIndex = 0;
        
        function getDayOfYear() {
            const now = new Date();
            const start = new Date(now.getFullYear(), 0, 0);
            const diff = (now - start) + ((start.getTimezoneOffset() - now.getTimezoneOffset()) * 60 * 1000);
            const oneDay = 1000 * 60 * 60 * 24;
            return Math.floor(diff / oneDay);
        }
        
        currentVerseIndex = getDayOfYear() % bibleVerses.length;
        
        function showVerse(index) {
            innerWrapper.style.opacity = '0';
            
            setTimeout(() => {
                const verse = bibleVerses[index];
                verseTextEl.textContent = `“${verse.text}”`;
                refBookEl.textContent = verse.book;
                refChapEl.textContent = verse.ref;
                
                innerWrapper.style.opacity = '1';
            }, 500); 
        }
        
        setTimeout(() => { showVerse(currentVerseIndex); }, 100);
        
        if (nextVerseBtn) {
            nextVerseBtn.addEventListener('click', () => {
                currentVerseIndex = (currentVerseIndex + 1) % bibleVerses.length;
                showVerse(currentVerseIndex);
            });
        }
    }
});
