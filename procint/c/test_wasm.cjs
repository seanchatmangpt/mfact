const fs = require('fs');

async function run() {
    const wasmBuffer = fs.readFileSync('/Users/sac/mfact/web/mfact-ui/src/assets/AtomVM_bridge.wasm');
    const wasmModule = await WebAssembly.compile(wasmBuffer);
    const instance = await WebAssembly.instantiate(wasmModule, {});
    const exports = instance.exports;

    console.log("WASM loaded successfully!");
    
    // Function to execute fire
    function fire(payload) {
        const payloadStr = JSON.stringify(payload);
        const encoder = new TextEncoder();
        const payloadBytes = encoder.encode(payloadStr);

        // Allocate memory
        const ptr = exports.alloc(payloadBytes.length);
        const mem = new Uint8Array(exports.memory.buffer);
        mem.set(payloadBytes, ptr);

        // Execute
        console.log("Calling execute with payload:", payloadStr);
        const resPtr = exports.execute(ptr, payloadBytes.length);

        // Read null-terminated result string
        let resLen = 0;
        const resMem = new Uint8Array(exports.memory.buffer, resPtr);
        while (resMem[resLen] !== 0) {
            resLen++;
        }
        const resBytes = new Uint8Array(exports.memory.buffer, resPtr, resLen);
        const decoder = new TextDecoder();
        const resStr = decoder.decode(resBytes);

        // Deallocate
        exports.dealloc(ptr, payloadBytes.length);
        exports.dealloc(resPtr, resLen + 1);

        return resStr;
    }

    // Test 1: Record Topology
    const res1 = fire("RECORD_TOPOLOGY");
    console.log("Test 1 Result:", res1);

    // Test 2: Fire t1 once (enabled)
    const payload2 = {
        net: {
            transitions: [
                { name: "t1", pre: [["p1", 1]], post: [["p2", 1]] }
            ]
        },
        marking: [["p1", 2], ["p2", 0]],
        fire: ["t1"]
    };
    const res2 = fire(payload2);
    console.log("Test 2 Result:", res2);

    // Test 3: Fire sequence t1, t1 (enabled)
    const payload3 = {
        net: {
            transitions: [
                { name: "t1", pre: [["p1", 1]], post: [["p2", 1]] }
            ]
        },
        marking: [["p1", 2], ["p2", 0]],
        fire: ["t1", "t1"]
    };
    const res3 = fire(payload3);
    console.log("Test 3 Result:", res3);
}

run().catch(console.error);
