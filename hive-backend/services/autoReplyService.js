class AutoReplyService {
  
  static REPLY_TEMPLATES = {
    'Phishing': [
      'Thanks for alerting me! I just verified my account. Can you confirm the verification code you sent?',
      'I clicked the link. It says I need to update my password. Is this the correct official website?',
      'I got an OTP. Should I share it with you to complete the verification?',
      'I\'m having trouble logging in. Can you help me reset my password?',
      'The page loaded but I\'m worried about my security. Should I change my password?'
    ],
    'Financial Fraud': [
      'I\'m interested! How much should I deposit to start?',
      'Which bank account should I transfer the money to?',
      'Can you send me more details about the guaranteed returns?',
      'What are the risks involved? How safe is this investment?',
      'Do you accept payments through other methods like credit card?'
    ],
    'Lottery Scam': [
      'Wow! I can\'t believe I won! What do I do now?',
      'What\'s the processing fee exactly? Can I pay it via bank transfer?',
      'How long does it take to receive my prize?',
      'Can I claim it through someone else or do I need to claim it myself?',
      'What documents do I need to provide for verification?'
    ],
    'SMS Spoofing': [
      'Thank you for notifying me! I\'ll take action immediately.',
      'I\'m worried. Can you help me secure my account?',
      'Should I change my password right now?',
      'Is my account compromised? What should I do?',
      'Can I verify this through the bank\'s official app?'
    ]
  };
  
  static FOLLOW_UP_SEQUENCES = {
    'verification': [
      'I shared my OTP, what\'s the next step?',
      'Did you receive my information? Should I do anything else?',
      'How long will verification take?',
      'Is there anything else you need from me?'
    ],
    'transfer': [
      'I\'m ready to transfer. What\'s the minimum amount?',
      'Should I transfer from my savings or current account?',
      'Can I do this through my mobile banking app?',
      'Will the money appear immediately in my account?'
    ],
    'payment': [
      'Is the processing fee refundable?',
      'Can I pay in installments?',
      'What if there\'s a problem with the transfer?',
      'Do you provide a guarantee for this?'
    ],
    'claim': [
      'I want to claim my prize! What documents do I need?',
      'When can I expect my money?',
      'Is there a contact person for this?',
      'How do I know this is legitimate?'
    ]
  };

  static generateAutoReply(spamMessage, spamType) {
    const typeReplies = this.REPLY_TEMPLATES[spamType] || this.REPLY_TEMPLATES['Phishing'];
    const randomIndex = Math.floor(Math.random() * typeReplies.length);
    return typeReplies[randomIndex];
  }

  static generateFollowUpSequence(currentStage) {
    return this.FOLLOW_UP_SEQUENCES[currentStage] || [];
  }

  static calculateEngagementMetrics(followUpReplies) {
    const timeWasted = followUpReplies.length * 180; // ~3 min per exchange
    const conversationTurns = followUpReplies.length;
    const persistence = conversationTurns > 3 ? 'High' : 'Low';
    
    return {
      timeWasted,
      conversationTurns,
      spammerPersistence: persistence,
      estimatedCostToSpammer: conversationTurns * 0.5
    };
  }
}

module.exports = AutoReplyService;
