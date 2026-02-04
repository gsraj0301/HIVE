class CallSimulationService {
  
  static CALL_FLOWS = {
    'banking': [
      {
        stage: 'Introduction',
        spammerMessage: 'Hello! Is this Mr/Ms [Name]? I\'m calling from your bank regarding suspicious activity on your account.',
        ourResponse: 'Yes, this is me. Oh no, what happened?',
        techniquesUsed: ['Authority Building', 'Urgency Creation']
      },
      {
        stage: 'Information Gathering',
        spammerMessage: 'We detected some unauthorized transactions. Can you verify your account number?',
        ourResponse: 'Sure, it\'s ****1234. Should I be worried?',
        techniquesUsed: ['Trust Building', 'Information Extraction']
      },
      {
        stage: 'Escalation',
        spammerMessage: 'Very serious. We need you to verify every transaction. Log into your banking app now.',
        ourResponse: 'I\'m logging in. What should I do?',
        techniquesUsed: ['Panic Inducement', 'Control Taking']
      },
      {
        stage: 'Exploitation',
        spammerMessage: 'Forward all your recent transactions screenshots to me immediately.',
        ourResponse: 'These are my recent ones... what should I do?',
        techniquesUsed: ['Emotional Manipulation', 'Demand Making']
      }
    ],
    'lottery': [
      {
        stage: 'Congratulation',
        spammerMessage: 'Congratulations! You\'ve been selected as a winner in our monthly lottery draw!',
        ourResponse: 'Really? I can\'t believe it! What do I do now?',
        techniquesUsed: ['Good News', 'Flattery']
      },
      {
        stage: 'Prize Details',
        spammerMessage: 'You\'ve won ₹50 lakhs! To claim your prize, you need to pay a processing fee of ₹5000.',
        ourResponse: 'That\'s amazing! How do I pay the fee?',
        techniquesUsed: ['Large Numbers', 'Urgency']
      },
      {
        stage: 'Payment Demand',
        spammerMessage: 'You can transfer the fee via bank transfer. Send it to this account...',
        ourResponse: 'Okay, let me arrange the money.',
        techniquesUsed: ['Direct Demand', 'Control']
      }
    ],
    'investment': [
      {
        stage: 'Opportunity',
        spammerMessage: 'Hi! I have an exclusive investment opportunity that returns 100% profit per month!',
        ourResponse: 'That sounds interesting. Tell me more.',
        techniquesUsed: ['Greed Exploitation', 'Exclusivity']
      },
      {
        stage: 'Guarantee',
        spammerMessage: 'We guarantee your money back with guaranteed returns. No risk at all!',
        ourResponse: 'How much do I need to invest?',
        techniquesUsed: ['False Promises', 'Risk Downplaying']
      },
      {
        stage: 'Pressure',
        spammerMessage: 'Limited slots available! I can only hold your seat for 1 hour. Send the money now!',
        ourResponse: 'Okay, I\'ll send the money quickly.',
        techniquesUsed: ['Artificial Scarcity', 'Time Pressure']
      }
    ]
  };

  static generateCallConversation(scamType = 'banking') {
    const flow = this.CALL_FLOWS[scamType] || this.CALL_FLOWS['banking'];
    return flow.map(conv => ({
      ...conv,
      timestamp: new Date()
    }));
  }

  static analyzeTechniques(conversation) {
    const techniques = {
      'Authority Building': ['bank', 'official', 'government', 'verified', 'company'],
      'Urgency Creation': ['urgent', 'immediately', 'asap', 'now', 'quickly', 'limited'],
      'Trust Building': ['secure', 'safe', 'verify', 'confirm', 'protect'],
      'Emotional Manipulation': ['worried', 'concerned', 'risk', 'danger', 'loss', 'fear'],
      'Greed Exploitation': ['profit', 'money', 'rich', 'wealth', 'returns', 'guarantee'],
      'Control Taking': ['do this', 'send me', 'transfer', 'give me', 'provide']
    };
    
    const detected = [];
    const contentLower = conversation.toLowerCase();
    
    for (const [technique, keywords] of Object.entries(techniques)) {
      if (keywords.some(kw => contentLower.includes(kw))) {
        detected.push(technique);
      }
    }
    
    return [...new Set(detected)];
  }

  static estimateCallDuration(stagesCount) {
    // ~45 seconds per stage
    return stagesCount * 45;
  }

  static calculateManipulationLevel(techniques) {
    const manipulationTechniques = [
      'Emotional Manipulation',
      'Greed Exploitation',
      'Control Taking',
      'Pressure Tactics',
      'Time Pressure',
      'Artificial Scarcity'
    ];
    
    const count = techniques.filter(t => manipulationTechniques.includes(t)).length;
    return Math.min(count * 2, 10); // Scale 0-10
  }
}

module.exports = CallSimulationService;
