class SpamDetectionService {
  
  static PHISHING_KEYWORDS = [
    'verify', 'confirm', 'update', 'urgent', 'action required', 'click here',
    'suspicious activity', 'account locked', 'unauthorized', 'validate',
    'confirm identity', 'verify account', 'security alert', 'unusual activity'
  ];
  
  static FINANCIAL_FRAUD_KEYWORDS = [
    'amount', 'transfer', 'payment', 'rupees', 'usd', 'bank', 'account',
    'processing fee', 'confirm', 'deposit', 'winner', 'claim', 'reward',
    'investment', 'profit', 'guarantee', 'return'
  ];
  
  static LOTTERY_KEYWORDS = [
    'congratulations', 'winner', 'lottery', 'prize', 'claim', 'selected',
    'lucky', 'reward', 'free', 'exclusive', 'bonus', 'jackpot', 'hit'
  ];
  
  static BANKING_KEYWORDS = [
    'hdfc', 'icici', 'axis', 'sbi', 'kotak', 'yes bank', 'bob', 'pnb',
    'otp', 'cvv', 'card', 'credit', 'debit', 'iban', 'ifsc'
  ];
  
  static SMS_SPOOFING_KEYWORDS = [
    'verify', 'confirm', 'click', 'link', 'update profile', 'activate',
    'restricted', 'blocked', 'suspended'
  ];

  static analyzeMessage(message) {
    let spamScore = 0;
    let detectedType = 'Unknown';
    const extractedKeywords = [];
    
    const content = message.toLowerCase();
    const contentLength = content.length;
    
    // Phishing Detection
    const phishingMatches = this.PHISHING_KEYWORDS.filter(kw => content.includes(kw));
    if (phishingMatches.length >= 2) {
      spamScore += 30;
      detectedType = 'Phishing';
      extractedKeywords.push(...phishingMatches);
    }
    
    // Financial Fraud Detection
    const fraudMatches = this.FINANCIAL_FRAUD_KEYWORDS.filter(kw => content.includes(kw));
    if (fraudMatches.length >= 3) {
      spamScore += 40;
      if (detectedType === 'Unknown') detectedType = 'Financial Fraud';
      extractedKeywords.push(...fraudMatches);
    }
    
    // Lottery Scam Detection
    const lotteryMatches = this.LOTTERY_KEYWORDS.filter(kw => content.includes(kw));
    if (lotteryMatches.length >= 2) {
      spamScore += 50;
      if (detectedType === 'Unknown') detectedType = 'Lottery Scam';
      extractedKeywords.push(...lotteryMatches);
    }
    
    // Banking Keywords Detection
    const bankingMatches = this.BANKING_KEYWORDS.filter(kw => content.includes(kw));
    if (bankingMatches.length >= 2) {
      spamScore += 35;
      extractedKeywords.push(...bankingMatches);
    }
    
    // URL Detection
    const urlPattern = /(https?:\/\/[^\s]+)/g;
    const urls = content.match(urlPattern) || [];
    if (urls.length > 0) {
      spamScore += 20;
      extractedKeywords.push(`Found ${urls.length} URLs`);
    }
    
    // Urgency Detection
    const urgencyWords = ['urgent', 'immediately', 'asap', 'now', 'quickly'];
    const urgencyMatches = urgencyWords.filter(w => content.includes(w));
    if (urgencyMatches.length > 0) {
      spamScore += 15;
    }
    
    // Suspicious Patterns
    if (content.includes('click') && content.includes('link')) spamScore += 10;
    if (content.includes('confirm') && content.includes('password')) spamScore += 10;
    if (content.match(/\d{10,}/)) spamScore += 5; // Phone numbers
    
    return {
      spamScore: Math.min(spamScore, 100),
      isSuspicious: spamScore >= 40,
      detectedType,
      keywords: [...new Set(extractedKeywords)],
      confidence: Math.round(spamScore)
    };
  }

  static extractIntelligence(message) {
    const intelligence = {
      phoneNumbers: [],
      emails: [],
      bankNames: [],
      amounts: [],
      urls: []
    };
    
    const content = message.toString();
    
    // Extract phone numbers (Indian format)
    const phoneRegex = /(\+91[-.\s]?)?[6-9]\d{9}/g;
    intelligence.phoneNumbers = content.match(phoneRegex) || [];
    
    // Extract emails
    const emailRegex = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g;
    intelligence.emails = content.match(emailRegex) || [];
    
    // Extract bank names
    const banks = ['HDFC', 'ICICI', 'Axis', 'SBI', 'Kotak', 'Yes Bank', 'BoB', 'PNB'];
    intelligence.bankNames = banks.filter(bank => 
      content.toUpperCase().includes(bank)
    );
    
    // Extract amounts
    const amountRegex = /[\$₹€£]\s*[\d,]+(?:\.\d{2})?/g;
    intelligence.amounts = content.match(amountRegex) || [];
    
    // Extract URLs
    const urlRegex = /(https?:\/\/[^\s]+)/g;
    intelligence.urls = content.match(urlRegex) || [];
    
    return intelligence;
  }

  static calculateSpammerEngagementTime(replyCount) {
    // Rough estimate: ~3 minutes per reply exchange
    return replyCount * 180;
  }

  static estimateTimeWasted(conversationTurns) {
    // Each turn is ~2-3 minutes for spammer
    return conversationTurns * 150;
  }
}

module.exports = SpamDetectionService;
