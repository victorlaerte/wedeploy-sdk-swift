/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import WeDeploy

public class Documentation {

	func intro_usingTheApiClient() {
		_ = WeDeploy.data("http://<serviceID>.<projectID>.wedeploy.io")
			.get(resourcePath: "movies")
			.then { movie -> Void in
				print(movie)
			}

		WeDeploy.data("http://<serviceID>.<projectID>.wedeploy.io")
			.get(resourcePath: "movies")
			.toCallback { movies, error in

			}

		_ = WeDeploy.data("http://<serviceID>.<projectID>.wedeploy.io")
			.get(resourcePath: "movies")
			.toObservable()
			.subscribe(
				onNext: { movies in
					// here you receive the movies
				},
				onError: { error in
					// oops something went wrong
				}
			)
	}

	func auth_manageUser() {
		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.createUser(email: "user@domain.com", password: "abc", name: "somename")
			.then { user -> Void in
				// Successfully created.
			}
			.catch { err in
				// Not created.
			}

		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.getCurrentUser()
			.then { user -> Void in
				// User found.
			}
			.catch { error in
				// User does not exist.
			}

		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.getUser(id: "userId")
			.then { user -> Void in
				// User found.
			}
			.catch { error in
				// User does not exist.
		}

		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.deleteUser(id: "userId")
			.then { _ -> Void in
				// Successfully deleted
			}
			.catch { err in
				// Not deleted.
		}

		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.updateUser(id: "userId" , email: "eleven@hawkinslabs.com", password: "password", name: "Eleven")
			.then { _ -> Void in
				// Successfully updated
			}
			.catch { err in
				// Not updated.
			}

		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.signOut()
			.then { _ -> Void in
				// Successfully signed out.
			}
			.catch { err in
				// Not signed out.
			}
	}

	func auth_SignInWithFacebook() {
		let auth = WeDeploy.auth("http://<serviceID>.<projectID>.wedeploy.io");
		let provider = AuthProvider(provider: .facebook, redirectUri: "my-app://")
		provider.providerScope = "email"

		auth.signInWithRedirect(provider: provider) { (user, error) in
			// Fires when user is signed in after redirect.
		}
	}

	func auth_SignInWithGithub() {
		let auth = WeDeploy.auth("http://<serviceID>.<projectID>.wedeploy.io");
		let provider = AuthProvider(provider: .github, redirectUri: "my-app://")
		provider.providerScope = "user:email"

		auth.signInWithRedirect(provider: provider) { (user, error) in
			// Fires when user is signed in after redirect.
		}
	}

	func auth_SignInWithGoogle() {
		let auth = WeDeploy.auth("http://<serviceID>.<projectID>.wedeploy.io");
		let provider = AuthProvider(provider: .google, redirectUri: "my-app://")
		provider.providerScope = "email"

		auth.signInWithRedirect(provider: provider) { (user, error) in
			// Fires when user is signed in after redirect.
		}
	}

	func auth_SignInWithEmailAndPassword() {
		WeDeploy
			.auth("http://<serviceID>.<projectID>.wedeploy.io")
			.signInWith(username: "user@domain.com", password: "password")
			.then { auth -> Void in
				// User is signed in.
			}
			.catch { err in
				// User is not signed in.
			}
	}

	func data_SaveData() {
		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.create(resource: "movies", object: [
				"title" : "Star Wars IV",
				"year" : 1977,
				"ratings" : 8.7
			])
			.then { movie in
				print(movie)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.create(resource: "movies", object: [
				[
					"title" : "Star Wars III",
					"year" : 2005,
					"ratings" : 8.0
				],
				[
					"title" : "Star Wars II",
					"year" : 2002,
					"ratings" : 8.6
				]
			])
			.then { movie in
				print(movie)
			}
		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.create(resource: "movies", object: [
				"title": "Star Wars I",
				"obs": "First in ABC order",
				"year": 1999,
				"rating": 9.0
			])
			.then { movie in
				print(movie)
			}
	}

	func data_UpdatingData() {
		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.update(resourcePath: "movies/115992383516607958", updatedAttributes: [
				"rating": 9.1
    		])
			.then { movie in
				print(movie)
		}
	}

	func data_deletingData() {
		let data = WeDeploy.data("http://<serviceID>.<projectID>.wedeploy.io")

		_ = data.delete(collectionOrResourcePath: "movies/star_wars_v/title")

		_ = data.delete(collectionOrResourcePath: "movies/star_wars_v")

		_ = data.delete(collectionOrResourcePath: "movies")
	}

	func data_retrievingData() {
		_ = WeDeploy.data("http://<serviceID>.<projectID>.wedeploy.io")
			.get(resourcePath: "movies/star_wars_v")
			.then { (movie: [String: Any]) in
				print(movie)
			}

		_ = WeDeploy.data("http://<serviceID>.<projectID>.wedeploy.io")
			.get(resourcePath: "movies/star_wars_v/title")
			.then { (movie: String) in
				print(movie)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.orderBy(field: "rating", order: .DESC)
			.get(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.where(field: "year", op: "<", value: 2000)
			.or(field: "rating", op: ">", value: 8.5)
			.get(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.where(field: "year", op: "<", value: 2000)
			.orderBy(field: "rating", order: .ASC)
			.limit(2)
			.offset(1)
			.get(resourcePath: "movies")
			.then { movies in
				print(movies)
			}
	}

	func data_SearchingData() {
		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.match(field: "title", pattern: "(jedi | force) -return")
			.get(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		// or this
		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.match(field: "title", pattern: "awake*")
			.get(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		// or even this
		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.match(field: "title", pattern: "wakens~")
			.get(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.similar(field: "title", query: "The attack an awaken Jedi uses to strike a Sith is pure force!")
			.search(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.similar(field: "title", query: "The attack an awaken Jedi uses to strike a Sith is pure force!")
			.highlight("title")
			.search(resourcePath: "movies")
			.then { movies in
				print(movies)
			}

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.lt(field: "year", value: 1990)
			.aggregate(name: "Old movies", field: "rating", op: "avg")
			.count()
			.get(resourcePath: "movies")
			.then { (aggregation: [String : Any]) in
				print(aggregation)
			}

		_ = WeDeploy
			.url("http://<serviceID>.<projectID>.wedeploy.io")
			.post(body: [
				"places" : [
					"location" : "geo_point"
				]
			])

		_ = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.any(field: "category", value: ["cinema"])
			.distance(field: "location", latitude: 51.5031653, longitude: -0.1123051, distance: .mile(1))
			.get(resourcePath: "places")
			.then { places in
				print(places)
			}
	}

	func data_realTime() {
		var socket = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.watch(resourcePath: "movies")

		socket.on([.changes, .error]) { data in
			switch(data.type) {
			case .changes:
				print("changes \(data.document)")
			case .error:
				print("error \(data.document)")
			default:
				break
			}
		}

		socket = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.where(field: "category", op: "=", value: "cinema")
			.or(field: "category", op: "=", value: "cartoon")
			.watch(resourcePath: "movies")

		socket.on([.changes, .error]) { data in
			switch(data.type) {
			case .changes:
				print("changes \(data.document)")
			case .error:
				print("error \(data.document)")
			default:
				break
			}
		}

		socket = WeDeploy
			.data("http://<serviceID>.<projectID>.wedeploy.io")
			.limit(1)
			.orderBy(field: "id", order: .DESC)
			.watch(resourcePath: "movies")

		socket.on([.changes, .error]) { data in
			switch(data.type) {
			case .changes:
				print("changes \(data.document)")
			case .error:
				print("error \(data.document)")
			default:
				break
			}
		}
	}

	func data_filteringData_operators() {
		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.where(field: "ratings", op: ">", value: 8.3)
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.where(field: "ratings", op: ">", value: 8.3)
			.where(field: "theaer", op: "=", value: "Regal")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.where(field: "theater", op: "=", value: "Regal")
			.or(field: "theater", op: "=", value: "CMA")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.gt(field: "ratings", value: "7")
			.lte(field: "ratings", value: "9.5")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.range(field: "ratings", range: Range(from: 4, to: 8))
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.none(field: "theaters", value: ["Regal", "AMC"])
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.any(field: "theaters", value: ["CMA"])
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.any(field: "theaters", value: ["Regal", "AMC"])
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.exists(field: "theaters")
			.get(resourcePath: "movies")
	}

	func data_filteringData_textQuery() {
		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.match(field: "title", pattern: "sith +Reveng -jedi")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.phrase(field: "title", value: "reven")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.similar(field: "title", query: "sth")
			.get(resourcePath: "movies")
	}

	func data_filteringData_geolocation() {
		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.polygon(field: "location", points: [GeoPoint(lat: 20, long: 0), GeoPoint(lat: 0, long: 20)])
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.distance(field: "location", latitude: 20, longitude: 0, distance: .mile(40))
			.get(resourcePath: "movies")
	}

	func data_filteringData_results() {
		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.match(field: "title", pattern: "Revenge")
			.limit(2)
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.match(field: "title", pattern: "Revenge")
			.offset(5)
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.match(field: "title", pattern: "Revenge")
			.highlight("title")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.aggregate(name: "my_averages", field: "ratings", op: "avg")
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.where(field: "ratings", op: ">", value: 8.5)
			.count()
			.get(resourcePath: "movies")

		_ = WeDeploy
			.data("https://<serviceID>-<projectID>.wedeploy.io")
			.where(field: "ratings", op: ">", value: 8.5)
			.orderBy(field: "title", order: .DESC)
			.get(resourcePath: "movies")
	}

	func email_checkStatus() {
		_ = WeDeploy.email("http://<serviceID>.<projectID>.wedeploy.io")
			.checkEmailStatus(id: "202605176596079530")
			.then { status in
				print("Email status: \(status)")
			}
			.catch { error in
			// Some error has happened
			}
	}

	var username = ""


	func email_sendEmail() {
		_ = WeDeploy
			.email("http://<serviceID>.<projectID>.wedeploy.io")
			.from(self.username)
			.to(self.username)
			.subject("subject")
			.message("body")
			.send()
			.then { id in
				print("Email ID: \(id)")
			}
			.catch { error in
				// Some error has happened
			}
	}
}

