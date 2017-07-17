var http = require('http'),
	qs = require('querystring'),
	aws = require('aws-sdk'),
	ses = new aws.SES({
		region: 'us-east-1'
	});

exports.handler = function(event, context, callback) {
	console.log('Event: ', JSON.stringify(event, null, '\t'));
	console.log('Context: ', JSON.stringify(context, null, '\t'));
	validateRecaptcha(
		event.secret,
		event.response,
		sendEmail.bind(this, message, context, event),
		this
	);
};

function validateRecaptcha(cSecret, cResponse, cb, scope) {
	let cSecret, cResponse;
	const postData = {
		secret: cSecret,
		response: cResponse
	};

	const options = {
		hostname: 'https://www.google.com/recaptcha/api/siteverify',
		method: 'POST',

		headers: {
			'Content-Length': Buffer.byteLength(postData)
		}
	};

	const req = http.request(options, res => {
		res.statusCode === 200 ? cb.call() : cb.call();
	});

	req.write(postData);
	req.end();
}

function sendEmail(message, context, event) {
	let email = {
		Destination: {
			ToAddresses: ['jlebonitte@gmail.com']
		},
		Message: {
			Body: {
				Text: {
					Data: message
				}
			},
			Subject: {
				Data: 'Inquiry From LebWebSolutions.com!'
			}
		},
		Source: 'admin@lebwebsolutions.com'
	};

	let email = ses.sendEmail(email, function(err, data) {
		if (err) {
			return console.log(err);
		}

		context.succeed();
	});
}
