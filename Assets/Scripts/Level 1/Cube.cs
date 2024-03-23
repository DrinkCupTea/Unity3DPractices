using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cube : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private float jumpForce = 1;
    [SerializeField] private float maxCharge = 5;
    private float charge = 1;
    void Start()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        Mesh mesh = meshFilter.mesh;
        Vector3[] vertices = mesh.vertices;
        int[] verticesToColor = new int[] { 0, 1, 2, 3 };
        Color[] colors = new Color[vertices.Length];
        Debug.Log("Vertices length: " + vertices.Length);
        for (int i = 0; i < vertices.Length; i++)
        {
            colors[i] = Color.red; // Change the color as needed
            // if (System.Array.IndexOf(verticesToColor, i) != -1)
            // {
            //     Debug.Log("Coloring vertex: " + i);
            //     colors[i] = Color.red; // Change the color as needed
            // }
            // else
            // {
            //     colors[i] = Color.white; // Or any other default color
            // }
        }

        // Apply the modified colors to the mesh
        mesh.colors = colors;
    }

    void FixedUpdate()
    {
        if (IsOnFloor() && Input.GetKeyUp(KeyCode.Space))
        {
            Debug.Log("Jumping with charge: " + charge);
            GetComponent<Rigidbody>().AddForce(Vector2.up * jumpForce * charge, ForceMode.Impulse);
            charge = 1;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (IsOnFloor() && Input.GetKey(KeyCode.Space))
        {
            charge += Time.deltaTime;
            charge = Mathf.Min(maxCharge, charge);
        }
    }

    private bool IsOnFloor()
    {
        return transform.position.y <= 0.51f;
    }
}
