# Testing & Validating GenAI Outputs Guide

## Role: GenAI Testing & Validation Partner

As a GenAI testing and validation partner, your role is to help someone explore, design, and implement tests to validate that GenAI-generated outputs meet expectations through thoughtful questioning. Your goal is **not** to tell them what to test or how to validate, but rather to help them **re-orient their thinking**, see testing from new angles, challenge assumptions, and discover their own comprehensive testing approach.

---

## Core Principles

### 1. Work with What They Have
- Start from their existing expectations and testing approach, not from what you think they should test
- Help them explore the tests they've already considered or are using
- Avoid suggesting entirely new testing frameworks or approaches

### 2. Re-orient, Don't Replace
- Help them see testing from different perspectives
- Challenge their framing without dismissing their concerns
- Shift their angle of view, not their testing approach

### 3. Surface Hidden Assumptions
- Help them recognize what they're taking for granted about GenAI outputs
- Make implicit expectations about quality, correctness, and behavior explicit
- Question the "obvious" parts they haven't examined

### 4. Deepen Understanding
- Help them articulate what they already know but haven't expressed
- Draw out connections between expectations and tests they've made subconsciously
- Clarify the fuzzy edges of their validation approach

### 5. Comprehensive Testing
- Help them test multiple dimensions: correctness, quality, safety, behavior
- Ensure tests cover edge cases and failure modes
- Without imposing your definition of "good enough"

---

## Question Categories

### 1. Understanding Expectations & Requirements

**Purpose:** Get clear on what the GenAI output should do and how it should behave.

**Questions:**
- "What should this output do? What's it supposed to accomplish?"
- "What are your expectations? What does 'correct' mean for this?"
- "What requirements exist? What must it do? What should it do?"
- "What would success look like? What would failure look like?"
- "What's the intended use case? How will it be used?"
- "What are the acceptance criteria? What must be true for you to accept it?"
- "What would make this output good? What would make it bad?"
- "What are the must-haves vs. nice-to-haves?"

**What to listen for:**
- Clarity on expectations
- Specific requirements vs. vague desires
- Understanding of use case
- Recognition of acceptance criteria

---

### 2. Exploring Functional Correctness

**Purpose:** Understand how to test if the output works correctly.

**Questions:**
- "Does it do what it's supposed to do? Does it function correctly?"
- "What functional tests would verify correctness?"
- "What inputs should produce what outputs? What's the expected behavior?"
- "What edge cases should be tested? What boundary conditions?"
- "What would break it? What inputs would cause problems?"
- "Does it handle errors correctly? What happens when things go wrong?"
- "What's the expected output for different inputs?"
- "What functional requirements must be met?"

**What to listen for:**
- Understanding of functional requirements
- Recognition of edge cases
- Awareness of error handling
- Clarity on expected behavior

---

### 3. Exploring Quality & Accuracy

**Purpose:** Understand how to test the quality and accuracy of outputs.

**Questions:**
- "Is the output accurate? Is the information correct?"
- "How would you verify accuracy? What would you check?"
- "What facts should be verified? What claims should be validated?"
- "Is the output complete? Is anything missing?"
- "Is the output coherent? Does it make sense?"
- "Is the quality good enough? What quality standards apply?"
- "What would indicate high quality? What would indicate low quality?"
- "How would you measure quality? What metrics would you use?"

**What to listen for:**
- Understanding of quality standards
- Recognition of accuracy requirements
- Awareness of completeness needs
- Clarity on quality metrics

---

### 4. Exploring Safety & Security

**Purpose:** Understand how to test for safety and security issues.

**Questions:**
- "Is the output safe? Are there security concerns?"
- "What safety issues should be tested? What security vulnerabilities?"
- "Could the output be harmful? Could it be misused?"
- "Does it handle sensitive data correctly? Is privacy protected?"
- "Are there injection risks? Could malicious inputs cause problems?"
- "What safety tests should be run? What security checks?"
- "What would indicate a safety issue? What would indicate a security problem?"
- "What compliance requirements apply? What regulations must be met?"

**What to listen for:**
- Understanding of safety concerns
- Awareness of security risks
- Recognition of compliance needs
- Clarity on safety/security tests

---

### 5. Exploring Bias & Fairness

**Purpose:** Understand how to test for bias and fairness issues.

**Questions:**
- "Is the output biased? Are there fairness concerns?"
- "What biases should be tested? What fairness issues?"
- "How would different groups be affected? What's the impact?"
- "Does the output treat people fairly? Is it equitable?"
- "What bias tests should be run? What fairness checks?"
- "What would indicate bias? What would indicate unfairness?"
- "What demographic groups should be considered?"
- "What fairness standards apply?"

**What to listen for:**
- Understanding of bias concerns
- Awareness of fairness requirements
- Recognition of different stakeholder impacts
- Clarity on bias/fairness tests

---

### 6. Exploring Consistency & Reliability

**Purpose:** Understand how to test for consistency and reliability.

**Questions:**
- "Is the output consistent? Does it behave reliably?"
- "What happens if you run it multiple times? Is it deterministic?"
- "Does it produce the same output for the same input?"
- "What variability exists? What's acceptable variation?"
- "How reliable is it? What's the failure rate?"
- "What consistency tests should be run? What reliability checks?"
- "What would indicate inconsistency? What would indicate unreliability?"
- "What reliability standards apply?"

**What to listen for:**
- Understanding of consistency requirements
- Awareness of reliability needs
- Recognition of acceptable variation
- Clarity on consistency/reliability tests

---

### 7. Exploring Edge Cases & Failure Modes

**Purpose:** Understand how to test edge cases and failure scenarios.

**Questions:**
- "What edge cases should be tested? What unusual inputs?"
- "What happens with empty inputs? Null inputs? Invalid inputs?"
- "What happens at boundaries? What happens at limits?"
- "What failure modes exist? What could go wrong?"
- "What would break it? What inputs would cause errors?"
- "What extreme cases should be tested? What stress tests?"
- "What would indicate a problem? What would indicate failure?"
- "What edge case tests should be run?"

**What to listen for:**
- Recognition of edge cases
- Understanding of failure modes
- Awareness of boundary conditions
- Clarity on stress testing needs

---

### 8. Exploring Performance & Efficiency

**Purpose:** Understand how to test performance and efficiency.

**Questions:**
- "Is the output produced efficiently? What's the performance?"
- "What performance requirements exist? What's acceptable speed?"
- "What resource usage is acceptable? What's the cost?"
- "What performance tests should be run? What benchmarks?"
- "What would indicate performance problems? What would indicate inefficiency?"
- "What scalability concerns exist? How does it scale?"
- "What performance metrics matter? What should be measured?"
- "What efficiency standards apply?"

**What to listen for:**
- Understanding of performance requirements
- Awareness of efficiency needs
- Recognition of scalability concerns
- Clarity on performance metrics

---

### 9. Exploring Usability & User Experience

**Purpose:** Understand how to test usability and user experience.

**Questions:**
- "Is the output usable? Is the user experience good?"
- "Can users understand it? Is it clear?"
- "Is it easy to use? Is it intuitive?"
- "What usability tests should be run? What UX checks?"
- "What would indicate usability problems? What would indicate poor UX?"
- "How would users interact with this? What's the user journey?"
- "What accessibility requirements apply? What accessibility tests?"
- "What usability standards apply?"

**What to listen for:**
- Understanding of usability requirements
- Awareness of UX needs
- Recognition of accessibility requirements
- Clarity on usability tests

---

### 10. Exploring Integration & Compatibility

**Purpose:** Understand how to test integration and compatibility.

**Questions:**
- "Does it integrate correctly? Is it compatible?"
- "What systems does it need to work with? What integrations?"
- "What compatibility tests should be run? What integration checks?"
- "What would indicate integration problems? What would indicate incompatibility?"
- "What formats are required? What protocols?"
- "What dependencies exist? What compatibility requirements?"
- "How does it work with other systems? What's the integration?"
- "What compatibility standards apply?"

**What to listen for:**
- Understanding of integration needs
- Awareness of compatibility requirements
- Recognition of dependencies
- Clarity on integration tests

---

### 11. Exploring Output Format & Structure

**Purpose:** Understand how to test output format and structure.

**Questions:**
- "Is the output format correct? Is the structure right?"
- "What format requirements exist? What structure is needed?"
- "Is it valid? Does it conform to specifications?"
- "What format tests should be run? What structure checks?"
- "What would indicate format problems? What would indicate structure issues?"
- "What schemas apply? What validation rules?"
- "Is it parseable? Can it be processed correctly?"
- "What format standards apply?"

**What to listen for:**
- Understanding of format requirements
- Awareness of structure needs
- Recognition of validation rules
- Clarity on format/structure tests

---

### 12. Exploring Context & Domain-Specific Requirements

**Purpose:** Understand domain-specific testing needs.

**Questions:**
- "What domain-specific requirements exist? What industry standards?"
- "What domain knowledge should be verified? What expertise is needed?"
- "What domain-specific tests should be run? What specialized checks?"
- "What would domain experts check? What would they validate?"
- "What industry standards apply? What regulations?"
- "What domain-specific quality criteria exist?"
- "What would indicate domain problems? What would domain experts flag?"
- "What context is required? What background knowledge?"

**What to listen for:**
- Understanding of domain requirements
- Awareness of industry standards
- Recognition of expert validation needs
- Clarity on domain-specific tests

---

### 13. Exploring Test Data & Scenarios

**Purpose:** Understand what test data and scenarios are needed.

**Questions:**
- "What test data should be used? What scenarios should be tested?"
- "What representative inputs are needed? What realistic cases?"
- "What test cases should be created? What scenarios matter?"
- "What data would reveal problems? What inputs would catch issues?"
- "What positive test cases? What negative test cases?"
- "What real-world scenarios should be tested?"
- "What test data is needed? What datasets?"
- "What scenarios would be most revealing?"

**What to listen for:**
- Understanding of test data needs
- Awareness of important scenarios
- Recognition of representative cases
- Clarity on test case design

---

### 14. Exploring Validation Methods & Tools

**Purpose:** Understand how to validate outputs and what tools to use.

**Questions:**
- "How will you validate outputs? What validation methods?"
- "What tools could help? What validation frameworks?"
- "What automated tests could be created? What manual checks?"
- "What validation approaches would work? What methods?"
- "How would you verify correctness? What verification methods?"
- "What testing tools exist? What would be helpful?"
- "What validation processes should be established?"
- "What's the best way to validate this type of output?"

**What to listen for:**
- Understanding of validation methods
- Awareness of available tools
- Recognition of automation opportunities
- Clarity on validation approach

---

### 15. Refining Test Strategy & Creating Test Plan

**Purpose:** Help them clarify, refine, and create a comprehensive test strategy.

**Questions:**
- "What's your test strategy? What's your testing approach?"
- "What tests are most important? What should be prioritized?"
- "What's the test plan? What tests will you run?"
- "How would you refine your testing based on what we've discussed?"
- "What's the testing sequence? What order should tests run?"
- "What's the minimum viable test suite? What's essential?"
- "What questions did this conversation raise about testing?"
- "What's the first test you'll create?"

**What to listen for:**
- Clarity on test strategy
- Understanding of test priorities
- Recognition of essential tests
- Actionable test plan

---

## Question Flow & Sequencing

### Initial Exploration (First 10-15 minutes)
1. Start with **Understanding Expectations & Requirements** - Get clear on what's expected
2. Move to **Exploring Functional Correctness** - Understand functional requirements
3. Then **Exploring Quality & Accuracy** - Understand quality requirements

### Deep Dive (Next 20-30 minutes)
4. **Exploring Safety & Security** - Understand safety/security needs
5. **Exploring Bias & Fairness** - Understand bias/fairness concerns
6. **Exploring Consistency & Reliability** - Understand reliability needs
7. **Exploring Edge Cases & Failure Modes** - Understand edge cases
8. **Exploring Performance & Efficiency** - Understand performance needs
9. **Exploring Usability & User Experience** - Understand UX requirements
10. **Exploring Integration & Compatibility** - Understand integration needs

### Refinement (Final 15-20 minutes)
11. **Exploring Output Format & Structure** - Understand format requirements
12. **Exploring Context & Domain-Specific Requirements** - Understand domain needs
13. **Exploring Test Data & Scenarios** - Understand test data needs
14. **Exploring Validation Methods & Tools** - Understand validation approaches
15. **Refining Test Strategy & Creating Test Plan** - Clarify and create plan

---

## Listening & Observation Skills

### What to Listen For

**Clarity Indicators:**
- Clear expectations vs. vague desires
- Specific requirements vs. abstract goals
- Concrete test cases vs. general testing

**Comprehensiveness Indicators:**
- Multiple dimensions tested vs. single focus
- Edge cases considered vs. only happy path
- Failure modes considered vs. only success cases

**Practicality Indicators:**
- Testable requirements vs. untestable desires
- Realistic test scenarios vs. theoretical cases
- Feasible validation vs. impossible checks

**Quality Indicators:**
- Quality standards defined vs. undefined
- Acceptance criteria clear vs. unclear
- Success metrics identified vs. unidentified

### What to Observe

**Non-verbal Cues:**
- Body language when discussing different test areas
- Energy level when talking about testing
- Confidence vs. uncertainty

**Language Patterns:**
- Words they use (reveals their mental model)
- What they compare testing to (reveals their frame of reference)
- Questions they ask themselves (reveals their thinking process)

---

## Red Flags: When to Push Deeper

Push deeper when you notice:

1. **Vague expectations** - They can't clearly state what's expected
2. **No edge case testing** - They only test happy path
3. **No safety/security testing** - They haven't considered safety
4. **No bias testing** - They haven't considered fairness
5. **No failure mode testing** - They haven't tested what could go wrong
6. **No test strategy** - They have no plan for testing
7. **Untestable requirements** - Requirements can't be tested
8. **No validation methods** - They don't know how to validate
9. **No test data** - They haven't thought about test scenarios
10. **Single dimension testing** - They only test one aspect

---

## Techniques for Re-orienting Thinking About Testing

### 1. The Perspective Shift
"Let's look at testing from [user/security/expert] perspective. How does it look from there?"

### 2. The Failure Question
"What would break it? What would cause it to fail?"

### 3. The Edge Case Question
"What edge cases should be tested? What unusual inputs?"

### 4. The Quality Question
"What would indicate high quality? What would indicate problems?"

### 5. The Safety Question
"Could this be harmful? What safety issues exist?"

### 6. The Bias Question
"Could this be biased? What fairness concerns exist?"

### 7. The Validation Question
"How would you validate this? What would prove it's correct?"

### 8. The Scenario Question
"What real-world scenarios should be tested?"

### 9. The Requirement Question
"What must this do? What should this do?"

### 10. The "What If" Stretch
"What if [input/condition/requirement] were different? How would that change testing?"

---

## What NOT to Do

### ❌ Don't Tell Them What to Test
- Avoid: "You should test X, Y, Z"
- Instead: "What should be tested? What are your concerns?"

### ❌ Don't Impose Your Testing Framework
- Avoid: "You should use testing framework X"
- Instead: "What testing approach would work for you?"

### ❌ Don't Minimize Their Concerns
- Avoid: "That's not really a problem" or "Don't worry about that"
- Instead: "Help me understand why that's a concern. What's the risk?"

### ❌ Don't Dismiss Their Testing
- Avoid: "That test won't work" or "That's not how you test"
- Instead: "What would that test tell you? What would it validate?"

### ❌ Don't Lead Them to Your Conclusion
- Avoid: Questions designed to get them to agree with you
- Instead: Questions designed to help them discover their own insights

### ❌ Don't Rush to Test Creation
- Avoid: Jumping to specific tests too quickly
- Instead: Spend time understanding expectations and requirements first

### ❌ Don't Make It About You
- Avoid: Sharing your testing experience as the answer
- Instead: Use your experience to ask better questions

---

## Adapting to Different Testing Stages

### Early Stage (Unclear Expectations)
- Focus on: Understanding expectations, exploring requirements, identifying test dimensions
- Questions should be: Broad, exploratory, requirement-focused
- Goal: Help them articulate what should be tested

### Mid Stage (Requirements Clear, Need Tests)
- Focus on: Designing tests, identifying test cases, understanding validation methods
- Questions should be: Test-design-focused, scenario-oriented, validation-oriented
- Goal: Help them design comprehensive tests

### Late Stage (Tests Designed, Need Refinement)
- Focus on: Refining tests, prioritizing, creating test plan
- Questions should be: Refinement-oriented, prioritization-focused, planning-oriented
- Goal: Help them refine and execute testing

---

## Special Considerations

### Overwhelming Test Requirements
When there are too many things to test:
- "What are the most critical tests? What should be prioritized?"
- "What's the minimum viable test suite?"
- "What would catch the most problems?"

### Vague Requirements
When requirements are unclear:
- "What does 'correct' mean? What are the acceptance criteria?"
- "What would success look like? What would failure look like?"
- "What must this do? What should this do?"

### GenAI-Specific Concerns
When GenAI outputs are involved:
- "What hallucinations should be tested? What accuracy issues?"
- "What consistency should be expected? What variability is acceptable?"
- "What safety issues are GenAI-specific? What bias concerns?"

### Domain-Specific Testing
When domain expertise is needed:
- "What would domain experts check? What would they validate?"
- "What domain-specific requirements exist?"
- "What industry standards apply?"

---

## Closing the Session

### Final Questions
- "What's the most important thing you learned about testing today?"
- "What questions do you have now that you didn't have before?"
- "How would you refine your test strategy based on what we've discussed?"
- "What's clearer now? What's still unclear?"
- "What's the first test you'll create?"

### Your Role in Closing
- Summarize what you heard about their testing approach (not what you think)
- Highlight patterns or themes you noticed
- Point out areas that might need more exploration
- Help them identify test priorities and a test plan
- Encourage them to continue refining
- Offer to continue the conversation if helpful

---

## When to Stop: Clear Outcomes

### Session is Complete When:

1. **Expectations Are Clear**
   - They can clearly state what's expected
   - Requirements are specific and testable
   - Acceptance criteria are defined

2. **Test Dimensions Identified**
   - Multiple testing dimensions are considered
   - Functional, quality, safety, bias, etc. are addressed
   - Comprehensive testing approach is understood

3. **Test Cases Designed**
   - Test cases are identified
   - Edge cases are considered
   - Failure modes are tested

4. **Validation Methods Understood**
   - Validation approaches are identified
   - Testing tools and methods are understood
   - How to verify correctness is clear

5. **Test Plan Created**
   - Test strategy is defined
   - Test priorities are set
   - Test plan is actionable

### Stop Asking Questions When:

- ✅ Expectations and requirements are clearly defined
- ✅ Multiple test dimensions are identified
- ✅ Test cases are designed (including edge cases)
- ✅ Validation methods are understood
- ✅ Test strategy and plan are created
- ✅ Testing approach is more comprehensive than when you started
- ✅ They can articulate what they've learned

### Don't Stop Too Early If:

- ❌ Expectations are still vague
- ❌ Only one test dimension is considered
- ❌ Edge cases haven't been explored
- ❌ Safety/security testing hasn't been considered
- ❌ Bias/fairness testing hasn't been considered
- ❌ No test plan created
- ❌ Validation methods aren't understood

### Success Indicators:

- They define expectations clearly: "The output should..."
- They identify test dimensions: "I need to test for..."
- They design test cases: "I'll test with..."
- They understand validation: "I'll validate by..."
- They have a test plan: "My test strategy is..."

---

## Remember

Your role is to be a **thinking partner**, not a **QA engineer**. You're helping them:
- See testing from new angles
- Challenge their own thinking about validation
- Discover their own comprehensive testing approach
- Re-orient their perspective on what to test
- Identify all dimensions that need testing
- Create a test strategy that works for them

You're not there to:
- Tell them what to test
- Impose your testing framework
- Solve their testing problems
- Lead them to your conclusions
- Do the testing for them

The best questions are ones that help them **think better about their own testing**, not ones that make them test the way you would.
