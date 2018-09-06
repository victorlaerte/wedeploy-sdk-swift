const fs = require('fs');

const fileContent = fs.readFileSync('FilterTests.swift').toString();

const regexJson = /assertJSON\(([^\)]*),\s*[^\)]*\)/g;
const regexFuncNames = /func test(.*)\(\)/g;

const jsons = executeRegex(fileContent, regexJson);
const funcNames = executeRegex(fileContent, regexFuncNames);

console.log(funcNames);
function executeRegex(content, regex, results = []) {
	let result = regex.exec(content);
	
	if (result == null) {
		return results;
	} 

	return executeRegex(content, regex, [...results, result[1]]);
}

const jsonsParsed = jsons.map(x => JSON.stringify(JSON.parse(eval(x)), null, 4));
const funcNamesParsed = funcNames.map(x => x.toLowerCase());


const zipped = jsonsParsed.reduce((acc, x, idx) => acc.concat([[x, funcNamesParsed[idx]]]), []);


zipped.forEach(([json, name]) => {
	fs.writeFileSync(`Snapshots/${name}.json`, json);
})