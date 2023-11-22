(
	async function () {
		const sleep = ms => new Promise(res => setTimeout(res, ms));
		while (true) {
			console.log("hello world");
			await sleep(5000);
		}
	}
)();
