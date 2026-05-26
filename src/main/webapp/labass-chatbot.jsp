<%-- ============================================================
     LABASS AI CHATBOT WIDGET
     Paste this entire block just before </body> in any JSP page.
     The chatbot knows your products and helps clients shop.
     ============================================================ --%>

<!-- ── CHATBOT STYLES ───────────────────────────────────────── -->
<style>
/* BUBBLE BUTTON */
#chat-bubble {
  position: fixed;
  bottom: 30px;
  right: 30px;
  width: 60px;
  height: 60px;
  background: #111;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 8px 25px rgba(0,0,0,0.25);
  z-index: 9999;
  transition: 0.3s;
  border: none;
}
#chat-bubble:hover { background: #896739; transform: scale(1.08); }
#chat-bubble svg   { width: 26px; height: 26px; fill: #fff; }

/* NOTIFICATION DOT */
#chat-bubble .notif {
  position: absolute;
  top: 4px; right: 4px;
  width: 12px; height: 12px;
  background: #e74c3c;
  border-radius: 50%;
  border: 2px solid #fff;
  animation: pulse 1.5s infinite;
}
@keyframes pulse {
  0%,100% { transform: scale(1); }
  50%      { transform: scale(1.3); }
}

/* CHAT WINDOW */
#chat-window {
  position: fixed;
  bottom: 105px;
  right: 30px;
  width: 370px;
  height: 520px;
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.18);
  display: flex;
  flex-direction: column;
  z-index: 9998;
  overflow: hidden;
  transform: scale(0.85) translateY(20px);
  opacity: 0;
  pointer-events: none;
  transition: all 0.3s cubic-bezier(0.34,1.56,0.64,1);
}
#chat-window.open {
  transform: scale(1) translateY(0);
  opacity: 1;
  pointer-events: all;
}

/* HEADER */
.chat-header {
  background: #111;
  color: #fff;
  padding: 16px 20px;
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}
.chat-avatar {
  width: 38px; height: 38px;
  background: #896739;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  flex-shrink: 0;
}
.chat-header-info h4 {
  font-family: 'Cinzel', serif;
  font-size: 14px;
  letter-spacing: 1px;
}
.chat-header-info p {
  font-size: 11px;
  color: #aaa;
  margin-top: 2px;
}
.online-dot {
  width: 8px; height: 8px;
  background: #2ecc71;
  border-radius: 50%;
  display: inline-block;
  margin-right: 4px;
}
.chat-close {
  margin-left: auto;
  background: transparent;
  border: none;
  color: #aaa;
  font-size: 22px;
  cursor: pointer;
  line-height: 1;
  transition: 0.2s;
}
.chat-close:hover { color: #fff; }

/* MESSAGES */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: #f8f6f3;
}
.chat-messages::-webkit-scrollbar { width: 4px; }
.chat-messages::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }

/* BUBBLES */
.msg {
  max-width: 82%;
  padding: 11px 15px;
  border-radius: 18px;
  font-size: 13.5px;
  line-height: 1.55;
  animation: msgIn 0.25s ease;
}
@keyframes msgIn { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }

.msg.bot {
  background: #fff;
  color: #222;
  align-self: flex-start;
  border-bottom-left-radius: 4px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.07);
}
.msg.user {
  background: #111;
  color: #fff;
  align-self: flex-end;
  border-bottom-right-radius: 4px;
}

/* TYPING INDICATOR */
.typing {
  display: flex;
  gap: 5px;
  padding: 12px 16px;
  background: #fff;
  border-radius: 18px;
  border-bottom-left-radius: 4px;
  align-self: flex-start;
  box-shadow: 0 2px 8px rgba(0,0,0,0.07);
}
.typing span {
  width: 7px; height: 7px;
  background: #bbb;
  border-radius: 50%;
  animation: bounce 1.2s infinite;
}
.typing span:nth-child(2) { animation-delay: 0.2s; }
.typing span:nth-child(3) { animation-delay: 0.4s; }
@keyframes bounce {
  0%,60%,100% { transform: translateY(0); }
  30%          { transform: translateY(-6px); }
}

/* QUICK REPLIES */
.quick-replies {
  display: flex;
  flex-wrap: wrap;
  gap: 7px;
  padding: 0 16px 10px;
  background: #f8f6f3;
}
.quick-btn {
  padding: 7px 13px;
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 20px;
  font-size: 12px;
  cursor: pointer;
  transition: 0.2s;
  color: #333;
  white-space: nowrap;
}
.quick-btn:hover { background: #111; color: #fff; border-color: #111; }

/* INPUT */
.chat-input-row {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  border-top: 1px solid #eee;
  gap: 10px;
  background: #fff;
  flex-shrink: 0;
}
#chat-input {
  flex: 1;
  border: 1px solid #e8e0d5;
  border-radius: 25px;
  padding: 10px 16px;
  font-size: 13px;
  outline: none;
  font-family: 'Inter', sans-serif;
  transition: 0.2s;
  background: #f8f6f3;
}
#chat-input:focus { border-color: #896739; background: #fff; }

#chat-send {
  width: 38px; height: 38px;
  border-radius: 50%;
  border: none;
  background: #111;
  color: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: 0.2s;
  flex-shrink: 0;
}
#chat-send:hover { background: #896739; }
#chat-send svg { width: 16px; height: 16px; fill: #fff; }

@media (max-width: 420px) {
  #chat-window { width: calc(100vw - 20px); right: 10px; bottom: 90px; }
}
</style>

<!-- ── CHATBOT HTML ───────────────────────────────────────────── -->

<!-- Bubble button -->
<button id="chat-bubble" onclick="toggleChat()" aria-label="Open chat">
  <svg viewBox="0 0 24 24"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
  <span class="notif"></span>
</button>

<!-- Chat window -->
<div id="chat-window">

  <div class="chat-header">
    <div class="chat-avatar">👗</div>
    <div class="chat-header-info">
      <h4>LABASS Assistant</h4>
      <p><span class="online-dot"></span>Online — here to help you shop</p>
    </div>
    <button class="chat-close" onclick="toggleChat()">×</button>
  </div>

  <div class="chat-messages" id="chat-messages"></div>

  <div class="quick-replies" id="quick-replies"></div>

  <div class="chat-input-row">
    <input id="chat-input" type="text" placeholder="Ask me anything about LABASS..." autocomplete="off">
    <button id="chat-send" onclick="sendMessage()">
      <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
    </button>
  </div>

</div>

<!-- ── CHATBOT JAVASCRIPT ─────────────────────────────────────── -->
<script>
// ── CONFIG ────────────────────────────────────────────────────
// Replace with your real Anthropic API key
const ANTHROPIC_API_KEY = "YOUR_ANTHROPIC_API_KEY_HERE";

// Your product catalog — keep this in sync with your database
const PRODUCT_CATALOG = [
  { id: 1, name: "Japanese Dress",      brand: "Ralph Lauren", price: 120, size: "M",   category: "dress",  desc: "Elegant dress for casual and formal occasions. Premium quality fabric." },
  { id: 2, name: "Black Elegant Dress", brand: "Zara",         price: 150, size: "S",   category: "dress",  desc: "Timeless black dress with a modern silhouette." },
  { id: 3, name: "Cardigan Outfit",     brand: "H&M",          price: 180, size: "L",   category: "outfit", desc: "Cozy cardigan paired with a matching black dress." },
];

// System prompt — tells the AI who it is and what it knows
const SYSTEM_PROMPT = `You are LABASS Assistant, a friendly and stylish shopping assistant for LABASS, a Moroccan fashion e-commerce brand. Your job is to help clients find the perfect outfit, answer questions about products, sizes, shipping, and guide them to checkout.

Here is the full product catalog you must use:
${JSON.stringify(PRODUCT_CATALOG, null, 2)}

Rules:
- Always be warm, helpful, and on-brand (elegant, fashion-forward)
- When recommending a product, always mention the name, price in DH, size, and a short reason why
- If the client wants to add to cart, tell them to click the cart icon on the product page or go to /product?id=X
- Shipping is FREE on all orders
- Payment methods: card, PayPal, Google Pay
- If you don't know something, say so honestly
- Keep answers short and conversational (2-4 sentences max)
- You can respond in French, Arabic (Darija), or English — match the language the client uses
- Never make up products that aren't in the catalog`;

// ── STATE ─────────────────────────────────────────────────────
let isOpen     = false;
let isTyping   = false;
let history    = [];   // full conversation history for context

const QUICK_REPLIES_DEFAULT = [
  "Show me all products 👗",
  "What's on sale? 🏷️",
  "Help me pick an outfit",
  "Shipping info 🚚",
  "What sizes do you have?",
];

// ── INIT ──────────────────────────────────────────────────────
window.addEventListener("DOMContentLoaded", () => {
  // Welcome message after 1 second
  setTimeout(() => {
    addBotMessage("Marhba bik! 👋 I'm your LABASS style assistant. I can help you find the perfect outfit, check sizes, or answer any questions. What are you looking for today?");
    showQuickReplies(QUICK_REPLIES_DEFAULT);
  }, 900);
});

// ── TOGGLE ────────────────────────────────────────────────────
function toggleChat() {
  isOpen = !isOpen;
  document.getElementById("chat-window").classList.toggle("open", isOpen);
  // Remove notification dot once opened
  const notif = document.querySelector("#chat-bubble .notif");
  if (isOpen && notif) notif.style.display = "none";
  if (isOpen) document.getElementById("chat-input").focus();
}

// ── SEND MESSAGE ──────────────────────────────────────────────
async function sendMessage(text) {
  const input = document.getElementById("chat-input");
  const userText = text || input.value.trim();
  if (!userText || isTyping) return;

  input.value = "";
  hideQuickReplies();
  addUserMessage(userText);

  // Add to history
  history.push({ role: "user", content: userText });

  // Show typing indicator
  showTyping();

  try {
    const reply = await callClaude(history);
    hideTyping();
    addBotMessage(reply);

    // Add bot reply to history
    history.push({ role: "assistant", content: reply });

    // Show contextual quick replies after each response
    showQuickReplies(getContextualReplies(userText));

  } catch (err) {
    hideTyping();
    addBotMessage("Sorry, I'm having a connection issue. Please try again in a moment. 😔");
    console.error("Chatbot error:", err);
  }
}

// ── CLAUDE API CALL ───────────────────────────────────────────
async function callClaude(messages) {
  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "anthropic-dangerous-direct-browser-access": "true"
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-20250514",
      max_tokens: 400,
      system: SYSTEM_PROMPT,
      messages: messages
    })
  });

  if (!response.ok) {
    const err = await response.json();
    throw new Error(err.error?.message || "API error");
  }

  const data = await response.json();
  return data.content[0].text;
}

// ── UI HELPERS ────────────────────────────────────────────────
function addBotMessage(text) {
  const msgs = document.getElementById("chat-messages");
  const div = document.createElement("div");
  div.className = "msg bot";
  div.innerHTML = formatMessage(text);
  msgs.appendChild(div);
  scrollToBottom();
}

function addUserMessage(text) {
  const msgs = document.getElementById("chat-messages");
  const div = document.createElement("div");
  div.className = "msg user";
  div.textContent = text;
  msgs.appendChild(div);
  scrollToBottom();
}

function showTyping() {
  isTyping = true;
  const msgs = document.getElementById("chat-messages");
  const div = document.createElement("div");
  div.className = "typing";
  div.id = "typing-indicator";
  div.innerHTML = "<span></span><span></span><span></span>";
  msgs.appendChild(div);
  scrollToBottom();
}

function hideTyping() {
  isTyping = false;
  const t = document.getElementById("typing-indicator");
  if (t) t.remove();
}

function showQuickReplies(replies) {
  const qr = document.getElementById("quick-replies");
  qr.innerHTML = "";
  replies.forEach(r => {
    const btn = document.createElement("button");
    btn.className = "quick-btn";
    btn.textContent = r;
    btn.onclick = () => sendMessage(r);
    qr.appendChild(btn);
  });
}

function hideQuickReplies() {
  document.getElementById("quick-replies").innerHTML = "";
}

function scrollToBottom() {
  const msgs = document.getElementById("chat-messages");
  msgs.scrollTop = msgs.scrollHeight;
}

// Make product links clickable in bot replies
function formatMessage(text) {
  // Bold **text**
  text = text.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>");
  // Line breaks
  text = text.replace(/\n/g, "<br>");
  return text;
}

// Show different quick replies based on what was just asked
function getContextualReplies(userText) {
  const t = userText.toLowerCase();
  if (t.includes("dress") || t.includes("robe"))
    return ["Show me Japanese Dress", "Show me Black Elegant Dress", "What sizes? 📏", "Add to cart 🛒"];
  if (t.includes("size") || t.includes("taille"))
    return ["I'm a size S", "I'm a size M", "I'm a size L", "Show all products"];
  if (t.includes("price") || t.includes("prix") || t.includes("thaman"))
    return ["Under 150 DH", "Show all products", "What's on sale? 🏷️"];
  if (t.includes("ship") || t.includes("livraison"))
    return ["How to pay? 💳", "Go to checkout →", "Show products"];
  return ["Show all products 👗", "Help me pick", "Go to checkout →"];
}

// ── KEYBOARD ──────────────────────────────────────────────────
document.getElementById("chat-input").addEventListener("keydown", e => {
  if (e.key === "Enter") sendMessage();
});
</script>
