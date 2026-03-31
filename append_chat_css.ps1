$css = @"

/* =========================================================================
   CHATBOT UI (WHATSAPP-STYLE)
   ========================================================================= */
.chatbot-toggle-btn {
    position: fixed;
    bottom: 20px;
    right: 20px;
    background: #0D6EFD;
    color: #fff;
    border: none;
    border-radius: 50%;
    width: 60px;
    height: 60px;
    font-size: 24px;
    cursor: pointer;
    box-shadow: 0 4px 15px rgba(13, 110, 253, 0.4);
    z-index: 10000;
    transition: transform 0.3s ease;
    display: flex;
    justify-content: center;
    align-items: center;
}
.chatbot-toggle-btn:hover {
    transform: scale(1.1);
    background: #FFC107;
    color: #111;
}

.chatbot-container {
    position: fixed;
    bottom: 90px;
    right: 20px;
    width: 350px;
    max-width: 90vw;
    height: 500px;
    max-height: 80vh;
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    display: flex;
    flex-direction: column;
    z-index: 9999;
    overflow: hidden;
    transition: all 0.3s ease;
    transform-origin: bottom right;
}
.chatbot-container.collapsed {
    transform: scale(0);
    opacity: 0;
    pointer-events: none;
}

.chatbot-header {
    background: #0D6EFD;
    color: #ffffff;
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.chatbot-title {
    font-weight: 600;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    gap: 10px;
    color: #ffffff !important;
}
#chatbot-close-btn {
    background: none;
    border: none;
    color: #fff;
    font-size: 1.2rem;
    cursor: pointer;
    transition: color 0.2s;
}
#chatbot-close-btn:hover {
    color: #FFC107;
}

.chatbot-messages {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    background: #E7F1FF; /* WhatsApp style light background */
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Chat Bubbles */
.chat-msg {
    max-width: 80%;
    padding: 10px 14px;
    border-radius: 14px;
    font-size: 0.95rem;
    line-height: 1.4;
    word-wrap: break-word;
    position: relative;
    animation: fadeInMsg 0.3s ease;
}
.chat-msg.bot {
    background: #ffffff;
    color: #333333;
    align-self: flex-start;
    border-bottom-left-radius: 4px;
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}
.chat-msg.user {
    background: #FFC107;
    color: #111111;
    align-self: flex-end;
    border-bottom-right-radius: 4px;
    box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}

@keyframes fadeInMsg {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.chatbot-quick-replies {
    padding: 10px 15px;
    background: #ffffff;
    display: flex;
    gap: 8px;
    overflow-x: auto;
    white-space: nowrap;
    border-bottom: 1px solid #eee;
}
.chatbot-quick-replies::-webkit-scrollbar {
    height: 4px;
}
.chatbot-quick-replies::-webkit-scrollbar-thumb {
    background: #ccc;
    border-radius: 4px;
}
.chat-qr-btn {
    background: #FFF8E1;
    border: 1px solid #FFC107;
    color: #111;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.85rem;
    cursor: pointer;
    transition: all 0.2s;
}
.chat-qr-btn:hover {
    background: #FFC107;
}

.chatbot-input-area {
    display: flex;
    padding: 15px;
    background: #ffffff;
    gap: 10px;
    border-top: 1px solid #eee;
}
#chatbot-input {
    flex: 1;
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-radius: 24px;
    outline: none;
    font-size: 0.95rem;
    transition: border-color 0.2s;
}
#chatbot-input:focus {
    border-color: #0D6EFD;
}
#chatbot-send-btn {
    background: #0D6EFD;
    color: #fff;
    border: none;
    border-radius: 50%;
    width: 44px;
    height: 44px;
    cursor: pointer;
    transition: background 0.2s;
    display: flex;
    justify-content: center;
    align-items: center;
}
#chatbot-send-btn:hover {
    background: #0A58CA;
}
.chat-typing {
    font-size: 0.85rem;
    color: #666;
    padding: 5px 15px;
    font-style: italic;
    background: transparent !important;
    box-shadow: none !important;
}
"@

$file = "public\styles.css"
Add-Content -Path $file -Value $css -Encoding UTF8
