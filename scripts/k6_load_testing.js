import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  ext: {
    loadimpact: {
      name: "Backend Load Testing",
    },
  },
  stages: [
    { duration: "30s", target: 50 }, // simulate ramp-up of traffic from 1 to 50 users over 5 minutes.
    // { duration: "1m", target: 50 }, // stay at 50 users for 2 minutes
    // { duration: "30s", target: 100 }, // ramp-up to 100 users in 1 minute
    // { duration: "1m", target: 100 }, // stay at 100 users for 2 minutes
    // { duration: "30s", target: 150 }, // ramp-up to 150 users in 15 seconds
    // { duration: "1m", target: 150 }, // stay at 150 users for 1 minute
    // { duration: "30s", target: 200 }, // ramp-up to 200 users in 15 seconds
    // { duration: "1m", target: 200 }, // stay at 200 users for 1 minute
    // { duration: "30s", target: 100 }, // ramp-down to 150 users in 15 seconds
    // { duration: "1m", target: 100 }, // stay at 100 users for 2 minutes
    // { duration: "30s", target: 0 }, // ramp-down to 0 users in 1 minute
  ],
};

const BASE_URL = "http://localhost:8080/";

export default () => {
  check(http.get(`${BASE_URL}`), {
    "is status 200 (GET)": (r) => r.status === 200,
  });

  sleep(1);
};
